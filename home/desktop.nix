{ pkgs, ... }:
{
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
    settings = {
      enabled_layouts = "splits, stack, fat, tall";
    };
    keybindings = {
      # Switch between active windows (panes) using arrow keys
      "ctrl+shift+left"  = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up"    = "neighboring_window up";
      "ctrl+shift+down"  = "neighboring_window down";

      # Splitting using easy punctuation keys (no AltGr needed)
      "ctrl+shift+period" = "launch --location=vsplit";  # Vertical split
      "ctrl+shift+comma"  = "launch --location=hsplit";  # Horizontal split
    };
  };

  home.packages = with pkgs; [
    # other GUI apps
  ];
}