{
  description = "NixOS + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    helix-notes.url = "git+https://gitlab.com/ArkHost/HelixNotes?ref=refs/tags/v1.3.6";
  };

  outputs = { nixpkgs, home-manager, helix-notes, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = [ inputs.nix-vscode-extensions.overlays.default ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Upstream hashes are stale, so override them here.
      helix-notes-pkg = helix-notes.packages.${system}.default.overrideAttrs (old: {
        pnpmDeps = old.pnpmDeps.overrideAttrs {
          outputHash = "sha256-iYyTATpiVf4/xkCmB3wjIcR71L2nMAqZuNJ6tlpb9qI=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (old) pname version src;
          hash = "sha256-t03bO221qKv0EL3h2e12G2qfKfaRW7BMYqTgKcYRYp8=";
        };
      });

      mkHost = hostName: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs helix-notes-pkg; };
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
        thinkpad = mkHost "ThinkPad" [
          ./hosts/thinkpad
          home-manager.nixosModules.home-manager
        ];

        # precision = mkHost "Precision" [
        #   ./hosts/precision
        #   inputs.nixflix.nixosModules.default
        # ];

        # deskmini = mkHost "DeskMini" [ ./hosts/deskmini ];
      };

      # home-manager on the CachyOS workstation
      homeConfigurations."john@cachyos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/john/cachyos.nix ];
        extraSpecialArgs = { inherit inputs helix-notes-pkg; };
      };
    };
}