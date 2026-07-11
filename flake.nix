{
  description = "Unified NixOS + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";

    mkSystem = { hostName, modules }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self;
          # available in NixOS modules as: pkgs-unstable.<pkg>
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = modules ++ [
          { networking.hostName = hostName; }
          { nixpkgs.config.allowUnfree = true; }
        ];
      };
  in
  {
    nixosConfigurations = {
      thinkpad = mkSystem {
        hostName = "ThinkPad";
        modules = [
          ./hosts/thinkpad
          home-manager.nixosModules.home-manager
        ];
      };

      /* precision = mkSystem {
        hostName = "Precision";
        modules = [ ./hosts/precision ];
      }; */

      /* deskmini = mkSystem {
        hostName = "DeskMini";
        modules = [ ./hosts/deskmini ];
      }; */
    };

    # home-manager on non-NixOS (CachyOS workstation) on unstable
    homeConfigurations."john@cachyos" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs-unstable { inherit system; };
      modules = [ ./home/john/cachyos.nix ];
      extraSpecialArgs = {
        inherit self;
        # optional, for consistency in HM modules:
        pkgs-unstable = import nixpkgs-unstable { inherit system; };
      };
    };
  };
}