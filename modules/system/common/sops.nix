# system/sops.nix
{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../../secrets/common.yaml;
    age.keyFile = if config.myOptions.isDesktop 
      then "/home/${config.myOptions.username}/.config/sops/age/keys.txt"
      else "/var/lib/sops-nix/key.txt";
    
    secrets."user/password" = { neededForUsers = true; };
    secrets."user/ssh_key" = { mode = "0444"; };
    secrets."couchdb/admin_password" = { owner = "couchdb"; };
    secrets."nextcloud/admin_password" = { owner = "nextcloud"; };
  };
}
