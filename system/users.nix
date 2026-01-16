# ~/nixos-config/system/users.nix
{ pkgs, ...}:
{
  users.users.nikitoskey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager"  ];
    shell = pkgs.fish;
  };
}
