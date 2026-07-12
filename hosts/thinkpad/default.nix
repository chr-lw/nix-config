{ config, lib, pkgs, pkgs-unstable, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos/common.nix
      ../../modules/nixos/desktop.nix
      ../../modules/nixos/kde.nix
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

    flatpak.enable = true;

    udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", NAME=="wlan*", RUN+="${pkgs.iw}/bin/iw reg set DK"
    '';

  };

  systemd = {
    network.wait-online.enable = false;     # Fix for losing internet connection after waking from hibernation
    services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];    # Make Tailscale work with nftables
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-utils
      ];
    };
  };

  security.rtkit.enable = true;

  environment = {
    systemPackages = with pkgs; [
      devenv
      nvtopPackages.amd
      powerstat
      quickemu
      distrobox
      networkmanager-openconnect
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  system.autoUpgrade.flake = "github:chr-lw/nix-config#thinkpad";
  system.stateVersion = "25.05";

}

