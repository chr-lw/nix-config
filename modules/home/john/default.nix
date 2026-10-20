{ pkgs, ... }:
{
  home.username = "john";
  home.stateVersion = "26.11";

  programs.git.enable = true;
  programs.zsh.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    ripgrep
    fd
  ];
}