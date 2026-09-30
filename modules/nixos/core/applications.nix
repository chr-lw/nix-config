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
  };

  environment.systemPackages = with pkgs; [
    # basics
    wget file tree jq lsof tealdeer

    # search and navigation
    ripgrep fd fzf ncdu

    # hardware, power, and video
    pciutils usbutils lm_sensors parted powertop libva-utils smartmontools

    # network
    dnsutils tcpdump

    # archive
    zip unzip libarchive

    # other
    podman-tui

  ];
}