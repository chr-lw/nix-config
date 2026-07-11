{ config, pkgs, pkgs-unstable, lib, ... }:
{
  services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
      ];
      browsed.enable = true;
    };

  users.groups.lpadmin = { };
  users.users.john.extraGroups = lib.mkAfter [ "lpadmin" "networkmanager" ];

  programs = {
    firefox.enable = true;
    partition-manager.enable = true;
    vscode = {
      enable = true;
      package = pkgs-unstable.vscode;
    };
  };

  environment.systemPackages = with pkgs; [
    nodejs-slim # Needed for the Copilot extension in IntelliJ and possibly VS Code
    python314
    jellyfin-desktop
  ];

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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.power-profiles-daemon.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };
}