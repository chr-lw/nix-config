{ pkgs, ... }:
{
  services.xserver.enable = true; # adjust if Wayland-only setup
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
  ];
}