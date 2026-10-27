{
  description = "NixOS + home-manager config";

  inputs = {
    # Base channel. Change to "github:NixOS/nixpkgs/nixos-26.11" once that branch exists.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Source for pkgs.unstable.* (VS Code and a few others). Stays on unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-notes = {
      url = "git+https://gitlab.com/ArkHost/HelixNotes?ref=refs/tags/v1.3.6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, helix-notes, ... }@inputs:
    let
      system = "x86_64-linux";

      unstableOverlay = _final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        };
      };

      overlays = [ unstableOverlay ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      mkHost = hostName: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs helix-notes; };
          modules = modules ++ [
            {
              networking.hostName = hostName;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = overlays;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        thinkpad = mkHost "ThinkPad" [ ./hosts/thinkpad ];

        # precision = mkHost "Precision" [
        #   ./hosts/precision
        #   inputs.nixflix.nixosModules.default
        # ];

        # deskmini = mkHost "DeskMini" [ ./hosts/deskmini ];
      };

      # home-manager on the CachyOS workstation
      homeConfigurations."john@cachyos" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.unstable;
        modules = [ ./home/cachyos.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}