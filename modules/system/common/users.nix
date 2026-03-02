# ~/nixos-config/system/users.nix
{ pkgs, config, ...}:
{
   users.users.${config.myOptions.username} = {
    isNormalUser = true;
    description = "Master of ${config.networking.hostName}";
    extraGroups = [ "wheel" "input" "networkmanager"  ];
    hashedPasswordFile = config.sops.secrets."user/password".path;
    shell = pkgs.fish;
  };
}
