{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
    defaultNetwork.settings = { 
      dns_enabled = true;
    };
  };

  programs = {
    zsh.enable = true;
    mosh.enable = true;
    traceroute.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    lm_sensors
    parted
    powertop
    libva-utils
    smartmontools
  ];
}