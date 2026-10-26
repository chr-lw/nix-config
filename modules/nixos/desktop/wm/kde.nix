{ config, pkgs, lib, ... }:
{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  systemd.user.services.kde-baloo = {
    overrideStrategy = "asDropin";
    environment.QT_QPA_PLATFORM = "offscreen";
  };

  systemd.user.services.plasma-plasmashell = {
    overrideStrategy = "asDropin";
    serviceConfig.TimeoutStopSec = "5s";
  }; # Remove this when KDE shutdown timeout bug is fixed

  programs = {
    kde-pim.enable = false;
    partition-manager.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadiconsole
    khelpcenter
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    kcalc
    konsole
  ];
}