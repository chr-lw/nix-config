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
        git.enable = true;
        home-manager.enable = true;
        htop.enable = true;
        jq.enable = true;
        mc.enable = true;
        ripgrep.enable = true;
        tealdeer.enable = true;

        fzf = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          tmux.enableShellIntegration = true;
          tmux.shellIntegrationOptions = [ "-d 40%" ];
        };
        
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
          packageConfigurable = pkgs.vim;
        };
        
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          history.size = 10000;
        };

        starship = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
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