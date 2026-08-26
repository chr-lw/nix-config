{ config, lib, pkgs, pkgs-unstable, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core
    ../../modules/nixos/server
    ../../modules/homelab
  ];

  system.autoUpgrade.flake = "github:chr-lw/nix-config#deskmini";
  system.stateVersion = "26.05";

  boot = {
    kernelpackages = pkgs.linuxPackages_6_12;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  supportedFilesystems = [ "zfs" ];
  zfs.package = pkgs.zfs_2_4;
  zfs.forceImportRoot = false;

  kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  zramSwap.enable = true;

  services.caddy = {
    enable = true;
    httpPort = null;
    openFirewall = true;
  };

  # Homelab services with Caddy integration and TLS.
  # These are defined in modules/services/*.nix and imported in modules/nixos/server.nix
  homelab.services = {

    cockpit = {
      enable = true;
      host = "cockpit.deskmini.home.arpa";
    };

  };

}