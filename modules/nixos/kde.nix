{ config, pkgs, pkgs-unstable, lib, ... }:
{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.kcalc
  ];
}