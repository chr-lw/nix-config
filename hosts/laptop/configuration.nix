{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # Home Manager as NixOS module on laptop
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.john = import ../../home/john/laptop.nix;

  # Example: enable NetworkManager for laptop
  networking.networkmanager.enable = true;
}