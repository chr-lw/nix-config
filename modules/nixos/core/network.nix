{ config, pkgs, lib, ... }:
{
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;

  services.openssh.enable = true;
  programs.mosh.enable = true;
  
}