{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/server.nix
  ];

  networking.useDHCP = true; # replace with static config if needed

  system.autoUpgrade.flake = "github:chr-lw/nix-config#precision";
}