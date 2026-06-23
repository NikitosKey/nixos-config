{ lib, ... }:
{
  services.openssh = {
    enable = lib.mkDefault true;
    ports = [ 7843 ];
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
      AuthorizedKeysFile = "%h/.ssh/authorized_keys /run/secrets/user/ssh_key";
    };
    openFirewall = lib.mkDefault true;
  };
}
