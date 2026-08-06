{ lib, config, ... }:
let
  cfg = config.homelab.services.linkding;
in {
  options.homelab.services.linkding = {
    enable = lib.mkEnableOption "Linkding with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "linkding.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 9091;
    };
  };

  config = lib.mkIf cfg.enable {
    services.linkding = {
      enable = true;
      port = cfg.port;
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}