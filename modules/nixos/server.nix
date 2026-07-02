{ ... }:
{
  # Server-focused defaults
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  # Common server hardening toggles can go here later
}