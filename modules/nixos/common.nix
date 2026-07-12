{ config, pkgs, pkgs-unstable, lib, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "john" ];
    auto-optimise-store = true;
  };

  nix.optimise = {
    automatic = true;
    dates = "weekly";
    persistent = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    allowReboot = false;
    randomizedDelaySec = "30min";
    persistent = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  time.timeZone = lib.mkDefault "Europe/Copenhagen";
  i18n.defaultLocale = lib.mkDefault "en_DK.UTF-8";
  console.keyMap = lib.mkDefault "dk";

  services.openssh.enable = true;

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  services.tailscale.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
  };

  programs = {
    git.enable = true;
    zsh.enable = true;
    mosh.enable = true;
    htop.enable = true;
    iotop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
    vim.enable = true;
    neovim.enable = true;
    nix-ld.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    parted
    lm_sensors
    powertop
    git
    curl
    wget
  ];

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
  };

  security.sudo.wheelNeedsPassword = true;

  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;
  services.zfs.autoScrub.enable = true;

  system.stateVersion = "25.05";
}