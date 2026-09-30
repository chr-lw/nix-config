{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk";

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
  };

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.fwupd.enable = true;
  services.zfs.autoScrub.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "john" ];
      auto-optimise-store = true;
    };

    optimise.automatic = true;

    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
  };

  system.autoUpgrade.enable = true;
  
}