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

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = [ inputs.nix-vscode-extensions.overlays.default ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost = hostName: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
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
        inherit pkgs;
        modules = [ ./home/john/cachyos.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}