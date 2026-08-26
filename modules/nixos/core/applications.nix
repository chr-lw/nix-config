{ pkgs, pkgs-unstable, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
    defaultNetwork.settings = { 
      dns_enabled = true;
    };
  };

  programs = {
    git.enable = true;
    zsh.enable = true;
    mosh.enable = true;
    htop.enable = true;
    iotop.enable = true;
    tmux.enable = true;
    traceroute.enable = true;
    vim.enable = true;
    neovim.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    parted
    lm_sensors
    powertop
    curl
    wget
    libva-utils
    pciutils
    tealdeer
    podman-tui
  ];
}