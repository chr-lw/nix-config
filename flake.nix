{
  description = "Unified NixOS + home-manager config";

  inputs = {
    # Conservative/stable pin:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    mkSystem = hostName: modules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self; };
        modules = modules ++ [
          { networking.hostName = hostName; }
        ];
      };
  in
  {
    nixosConfigurations = {
      laptop = mkSystem "laptop" [
        ./hosts/laptop/configuration.nix
      ];

      server-a = mkSystem "server-a" [
        ./hosts/server-a/configuration.nix
      ];

      server-b = mkSystem "server-b" [
        ./hosts/server-b/configuration.nix
      ];
    };

    # home-manager on non-NixOS (CachyOS workstation)
    homeConfigurations."john@cachyos" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ ./home/john/cachyos.nix ];
      extraSpecialArgs = { inherit self; };
    };
  };
}