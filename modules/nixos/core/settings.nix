{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk";

  environment.pathsToLink = [ "/share/zsh" ];

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    shell = pkgs.zsh;
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

      http-connections = 50;
      max-substitution-jobs = 32;
      download-buffer-size = 524288000;  # 500 MiB; avoids "download buffer is full" stalls
      connect-timeout = 5;
      fallback = true;                   # build locally if a cache is unreachable
    };

    optimise.automatic = true;

    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
  };

  system.autoUpgrade.enable = true;
  
}