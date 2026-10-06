{
  description = "Unified NixOS + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    helix-notes = {
      url = "git+https://gitlab.com/ArkHost/HelixNotes";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixflix,
    nix-vscode-extensions,
    helix-notes,
    ...
  }@inputs:
  let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    helix-notes-pkg = helix-notes.packages.${system}.default.overrideAttrs (_oldAttrs: {
      cargoHash = nixpkgs.lib.fakeHash;
    });

    mkSystem = { hostName, modules }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self inputs system pkgs-unstable;
          inherit helix-notes-pkg;
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
        modules = [
          ./hosts/precision
          nixflix.nixosModules.default
        ];
      }; */

      /* deskmini = mkSystem {
        hostName = "DeskMini";
        modules = [ ./hosts/deskmini ];
      }; */
    };

    # home-manager on non-NixOS (CachyOS workstation) on unstable
    homeConfigurations."john@cachyos" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs-unstable;
      modules = [ ./home/john/cachyos.nix ];

      extraSpecialArgs = {
        inherit self inputs pkgs-unstable;
      };
    };
  };
}