{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

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