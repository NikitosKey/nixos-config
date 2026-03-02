{ lib, ... }:
{
  services.openssh = {
    enable = lib.mkDefault true;
    ports = [ 7843 ];
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
    };
    openFirewall = lib.mkDefault true;
  };
}
