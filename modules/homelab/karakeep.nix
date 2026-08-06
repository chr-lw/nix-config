{ lib, config, ... }:
let
  cfg = config.homelab.services.karakeep;
in {
  options.homelab.services.karakeep = {
    enable = lib.mkEnableOption "Karakeep with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "karakeep.precision.home.arpa";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.karakeep = {
      enable = true;
      package = pkgs-unstable.karakeep;
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}