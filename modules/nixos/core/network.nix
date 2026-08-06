{ config, pkgs, pkgs-unstable, lib, ... }:
{
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ]; # Make Tailscale work with nftables

  services.openssh.enable = true;
}