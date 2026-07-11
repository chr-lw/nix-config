{ config, lib, pkgs, pkgs-unstable, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];
    zfs.package = pkgs.zfs_2_4;
    zfs.forceImportRoot = false;

    initrd.systemd.network.wait-online.enable = false;

    kernelParams = [
      "amdgpu.dcfeaturemask=0x2"
      "amdgpu.runpm=1"
      "amdgpu.sg_display=0"
      "iommu=pt"
      "nvme_core.default_ps_max_latency_us=0"
      "amd_pstate=active"
      "zfs.zfs_arc_max=25769803776" # 24GB in bytes
      "cfg80211.regdomain=DK"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };

  fileSystems."/" = {
    device = "tank/root";
    fsType = "zfs";
  };
  fileSystems."/nix" = {
    device = "tank/nix";
    fsType = "zfs";
  };
  fileSystems."/var" = {
    device = "tank/var";
    fsType = "zfs";
  };
  fileSystems."/home" = {
    device = "tank/home";
    fsType = "zfs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9E41-9775";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/322c153f-5e56-481b-a0bf-46f5713aa200";
      randomEncryption.enable = true;
      priority = 0;
    }
  ];

  zramSwap.enable = true;

  networking = {
    hostId = "4b3c47ff"; # NEVER change this!!!
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    nftables.enable = true;

    nameservers = [
      # Mullvad base DNS
      "194.242.2.4"
      
      # Quad9
      "9.9.9.9"
      "149.112.112.112"

      # Cloudflare
      "1.1.1.1"
    ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = false; # This sometimes breaks my connection on eduroam.
      unmanaged = [ "interface-name:p2p-dev-*" ];
      plugins = with pkgs; [
        networkmanager-openconnect # This is for my university's VPN, based on Cisco AnyConnect.
      ];
    };
  };

  services = {
    resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };

    tailscale.enable = true;

    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;

    power-profiles-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    fwupd.enable = true;
    flatpak.enable = true;

    zfs.autoScrub.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
      ];
      browsed.enable = true;
    };

    udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", NAME=="wlan*", RUN+="${pkgs.iw}/bin/iw reg set DK"
    '';

  };

  systemd = {
    network.wait-online.enable = false;     # Fix for losing internet connection after waking from hibernation
    services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];    # Make Tailscale work with nftables
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-utils
      ];
    };
  };

  time.timeZone = "Europe/Copenhagen";
  console.keyMap = "dk";
  i18n.defaultLocale = "en_DK.UTF-8";

  security.rtkit.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
  };

  programs = {
    firefox.enable = true;
    mosh.enable = true;
    neovim.enable = true;
    partition-manager.enable = true;
    direnv.enable = true;
    nix-ld.enable = true; # Needed for VS Code to work with direnv
  };

  environment = {
    systemPackages = with pkgs; [
      parted
      lm_sensors
      devenv
      nodejs-slim # Needed for the Copilot extension in IntelliJ and possibly VS Code
      python314
      nvtopPackages.amd
      powertop
      powerstat
      jellyfin-desktop
      quickemu
      distrobox
      networkmanager-openconnect
      pkgs-unstable.vscode
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      khelpcenter
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      libertinus
      noto-fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.jetbrains-mono
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true;
    };

    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };

    settings = {
      trusted-users = [ "root" "john" ];
      auto-optimise-store = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    allowReboot = false;
    randomizedDelaySec = "30min";
    persistent = true;
  };

  users = {
    groups.lpadmin = { };
    users.john = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "lpadmin" "podman" ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

