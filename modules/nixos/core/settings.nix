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

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 14d";
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      http-connections = 50;
      max-substitution-jobs = 32;
      download-buffer-size = 268435456;  # 256 MB
      connect-timeout = 5;
      fallback = true;
    };

    optimise.automatic = true;
  };

  system.autoUpgrade.enable = true;
  
}