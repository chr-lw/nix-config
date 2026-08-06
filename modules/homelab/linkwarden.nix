{ lib, config, ... }:
let
  cfg = config.homelab.services.linkwarden;
in {
  options.homelab.services.linkwarden = {
    enable = lib.mkEnableOption "Linkwarden with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "linkwarden.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
    };
  };

  config = lib.mkIf cfg.enable {
    services.linkwarden = {
      enable = true;
      port = cfg.port;
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}