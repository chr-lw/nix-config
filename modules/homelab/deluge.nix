{ lib, config, ... }:
let
  cfg = config.homelab.services.deluge;
in {
  options.homelab.services.deluge = {
    enable = lib.mkEnableOption "Deluge with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "deluge.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8112;
    };
  };

  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      web = {
        enable = true;
        port = cfg.port;
      };
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}