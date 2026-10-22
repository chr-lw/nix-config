{ config, pkgs, lib, ... }:
{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  systemd.user.services.kde-baloo = {
    overrideStrategy = "asDropin";
    environment.QT_QPA_PLATFORM = "offscreen";
  };

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
  ];
}