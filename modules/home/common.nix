{ pkgs, ... }:
{
  home.username = "john";
  home.stateVersion = "26.05";

  programs.git.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    htop
    tree
    ripgrep
    fd
  ];
}