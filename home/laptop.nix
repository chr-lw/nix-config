{ ... }:
{
  imports = [ ../modules/home/common.nix ];

  # laptop-specific HM config
  programs.git = {
    userName = "john";
    userEmail = "john@example.com"; # change me
  };
}