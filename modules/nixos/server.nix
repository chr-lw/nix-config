{ ... }:
{
  # Server-focused defaults
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  hardware.graphics.extraPackages = with pkgs; [
    libva
    intel-media-driver
  ];

}