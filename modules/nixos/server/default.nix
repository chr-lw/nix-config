{ config, lib, pkgs, pkgs-unstable, ... }:
{
  # Both servers have Intel graphics
  hardware.graphics.extraPackages = with pkgs; [
    libva
    intel-media-driver
    intel-compute-runtime
  ];

  # Enable Caddy reverse proxy for all services. Force everything to https on port 443.
  services.caddy = {
    enable = true;
    httpPort = null;
    openFirewall = true;
  };

}