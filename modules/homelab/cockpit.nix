{ lib, config, ... }:
let
  cfg = config.homelab.services.cockpit;
in {
  options.homelab.services.cockpit = {
    enable = lib.mkEnableOption "Cockpit with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "cockpit.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
    };
  };

  config = lib.mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      package = pkgs-unstable.cockpit;
      plugins = with pkgs-unstable; [
        cockpit-zfs
        cockpit-files
        # cockpit-podman
        # cockpit-machines
      ];
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}