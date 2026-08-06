{ lib, config, ... }:
let
  cfg = config.homelab.services.homer;
in {
  options.homelab.services.homer = {
    enable = lib.mkEnableOption "Homer with Caddy reverse proxy";
    host = lib.mkOption {
      type = lib.types.str;
      example = "homer.precision.home.arpa";
    };
  };

  config = lib.mkIf cfg.enable {
    services.freshrss = {
      enable = true;
      virtualHost.caddy.enable = true;
      virtualHost.domain = cfg.host;
      
    };

    services.caddy.virtualHosts.${cfg.host}.extraConfig = ''
      tls internal
    '';
  };
}