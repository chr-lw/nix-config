{
  home-manager.users.john = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-marketplace; [
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          mkhl.direnv
          ms-python.python
          ms-toolsai.jupyter
          redhat.vscode-yaml
          myriad-dreamin.tinymist
          mathematic.vscode-pdf
        ];
      };
    };

    programs.kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
      font.size = 12;
      themeFile = "citylights";
    };

    home.packages = with pkgs; [
      # other GUI apps
    ];
  };
}