{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./homelab.nix
    ../../modules/nixos/core
    ../../modules/nixos/server.
  ];

  system.autoUpgrade.flake = "github:chr-lw/nix-config#precision";
  system.stateVersion = "26.05";

  fileSystems."/" = {
    device = "tank/root";
    fsType = "zfs";
  };
  fileSystems."/nix" = {
    device = "tank/nix";
    fsType = "zfs";
  };
  fileSystems."/var" = {
    device = "tank/var";
    fsType = "zfs";
  };
  fileSystems."/home" = {
    device = "tank/home";
    fsType = "zfs";
  };

  zramSwap.enable = true;

  services.hddfancontrol = {
    enable = true;
  };

}