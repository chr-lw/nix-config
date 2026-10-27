{ inputs, lib, pkgs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };

    # All home-manager modules see unstable as their 'pkgs'
    # To install packages from the stable channel, just declare them system-wide in the relevant config file.
    sharedModules = [
      { _module.args.pkgs = lib.mkForce pkgs.unstable; }
    ];

    users.john.imports = [ ../../../home/core.nix ];
  };
}