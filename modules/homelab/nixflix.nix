{ config, pkgs, pkgs-unstable, lib, ... }:
{
  nixflix = {
    enable = true;
    
    mediaDir = "/data/media"; # This should be on the hdd pool
    # stateDir = "/data/.state"; # Defaults to /var/lib when commented out. Don't know what is best
    downloadsDir = "/data/downloads"; # This should be on the nvme pool to prevent the hdds from spinning when downloading
    
    mediaUsers = [ "john" ];

    serviceDependencies = [
      "tailscale.service"
    ];

    caddy = {
      enable = true;
      domain = "precision.home.arpa";
      tls.enable = true;
      tls.internal = true;
    };

    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."sonarr/api_key".path;};
        hostConfig.password = {_secret = config.sops.secrets."sonarr/password".path;};
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."radarr/api_key".path;};
        hostConfig.password = {_secret = config.sops.secrets."radarr/password".path;};
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = {_secret = config.sops.secrets."prowlarr/api_key".path;};
        hostConfig.password = {_secret = config.sops.secrets."prowlarr/password".path;};
      };
    };

    sabnzbd = {
      enable = true;
      settings = {
        misc.api_key = {_secret = config.sops.secrets."sabnzbd/api_key".path;};
      };
    };

    jellyfin = {
      enable = true;
      users.admin = {
        policy.isAdministrator = true;
        password = {_secret = config.sops.secrets."jellyfin/admin_password".path;};
      };
    };
  };
}