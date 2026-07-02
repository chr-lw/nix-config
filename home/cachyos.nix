{ ... }:
{
  imports = [ ../../modules/home/common.nix ];

  # non-NixOS HM requires this
  home.homeDirectory = "/home/john";

  programs.git = {
    userName = "john";
    userEmail = "john@example.com"; # change me
  };
}