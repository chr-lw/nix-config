{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    
    users.john = { config, pkgs, ... }: {
      home.username = "john";
      home.homeDirectory = "/home/john";
      home.stateVersion = "26.11";

      programs = {
        fd.enable = true;
        fzf = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          tmux.enableShellIntegration = true;
          tmux.shellIntegrationOptions = [ "-d 40%" ];
        };
        git.enable = true;
        home-manager.enable = true;
        htop.enable = true;
        jq.enable = true;
        mc.enable = true;
        ripgrep.enable = true;
        tealdeer.enable = true;
        tmux = {
          enable = true;
          baseIndex = 1;
          clock24 = true;
          mouse = true;
          terminal = "screen-256color";
        };
        vim = {
          enable = true;
          defaultEditor = true;
        };
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
        };
      };

      home.packages = with pkgs; [
        file
        libarchive
        lsof
        nvd
        ripgrep
        tree
        zip
        unzip
      ];
    };
  };
}