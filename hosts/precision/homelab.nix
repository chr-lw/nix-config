{ ... }:
{
  ## Homelab services with Caddy integration and TLS.
  ## These are defined in modules/homelab/

  imports = [
    ../../modules/homelab
  ];

  homelab.services = {

    audiobookshelf = {
      enable = true;
      host = "audiobookshelf.precision.home.arpa";
      port = 8000;
    };

    cockpit = {
      enable = true;
      host = "cockpit.precision.home.arpa";
      port = 9090;
    };

    deluge = {
      enable = true;
      host = "deluge.precision.home.arpa";
      port = 8112;
    };

    freshrss = {
      enable = true;
      host = "freshrss.precision.home.arpa";
      baseUrl = "https://freshrss.precision.home.arpa";
    };

    homer = {
      enable = true;
      host = "homer.precision.home.arpa";
    };

    karakeep = {
      enable = true;
      host = "karakeep.precision.home.arpa";
      port = 3000;
    };

    linkding = {
      enable = true;
      host = "linkding.precision.home.arpa";
      port = 9091;
    };

    linkwarden = {
      enable = true;
      host = "linkwarden.precision.home.arpa";
      port = 3001;
    };
    
  };

}