{ config, lib, pkgs, pkgs-unstable, ... }:
{
  # Server-focused defaults
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  # Both servers have Intel graphics, so we can enable the same packages for both.
  hardware.graphics.extraPackages = with pkgs; [
    libva
    intel-media-driver
    intel-compute-runtime
  ];

}