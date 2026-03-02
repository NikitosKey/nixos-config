# ~/nixos-config/home-manager/cli/aliases.nix
{ pkgs, ...}:

{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
    shellAliases = {
      rbs = "sudo nixos-rebuild switch --flake ~/nixos-config";
      rbt = "sudo nixos-rebuild test --flake ~/nixos-config";
      fu = "nix flake update --flake ~/nixos-config";
    };
  };
}
