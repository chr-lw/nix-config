{ config, pkgs, lib, ... }:
{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  systemd.user.services.kde-baloo.environment.QT_QPA_PLATFORM = "offscreen";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadiconsole
    khelpcenter
    kmail
    kontact
    ktnef
    merkuro
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    kcalc
  ];
}