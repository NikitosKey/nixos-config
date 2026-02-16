# ~/nixos-config/system/users.nix
{ pkgs, ...}:
{
  users.users.nikitoskey = {
    hashedPassword = "$7$CU..../....uiYSM0OykxUFl6GUuTQ7A1$GpFaIGAS3sFY6KNCc2SuaChxwPzRss3APHcrVsOLHc3";
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager"  ];
    shell = pkgs.fish;
  };
}
