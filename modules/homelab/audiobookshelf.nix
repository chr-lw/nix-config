{ lib, config, ... }:
let
  cfg = config.homelab.services.audiobookshelf;
in {
  options.homelab.services.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobookshelf with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "audiobookshelf.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      port = cfg.port;
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}