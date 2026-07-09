{ pkgs, ... }:
{
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
  ];
}