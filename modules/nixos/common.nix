{ config, pkgs, lib, ... }:

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



  time.timeZone = lib.mkDefault "UTC";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  services.openssh.enable = true;

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
  };

  # Useful baseline packages
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
  ];

  # enable sudo for wheel
  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.05";
}