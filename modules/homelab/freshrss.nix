{ lib, config, ... }:
let
  cfg = config.homelab.services.freshrss;
in {
  options.homelab.services.freshrss = {
    enable = lib.mkEnableOption "FreshRSS with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "freshrss.precision.home.arpa";
    };
    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "/";
    };
  };

  config = lib.mkIf cfg.enable {
    services.freshrss = {
      enable = true;
      baseUrl = cfg.baseUrl;
      webserver = "caddy";
      virtualHost = cfg.host;
      extensions = with pkgs.freshrss-extensions; [
        youtube
        title-wrap
        reading-time
      ];
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
    '';
  };
}