# ~/nixos-config/nixos/users.nix
{ pkgs, ...}:
{
  users.users.nikitoskey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager" "audio" "pipewire" "kvm" "fuse" "video" "render" ];
    shell = pkgs.fish;
  };
}
