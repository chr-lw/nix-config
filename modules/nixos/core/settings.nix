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
  security.sudo.wheelNeedsPassword = true;

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

    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };

    gc = {
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
  
}