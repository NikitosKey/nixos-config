{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      gc = "sudo nix-collect-garbage -d";
      nv = "nvim";
      ssh = "kitten ssh";
      grbs = "sudo nixos-rebuild switch --flake github:NikitosKey/nixos-config";
      grbt = "sudo nixos-rebuild test --flake github:NikitosKey/nixos-config";
      mc-console = "sudo nixos-container run minecraft-server -- mcrcon -p 'AHAHAHAH_SOSAL?!' -t";
      mc-log = "TERM=xterm-256color sudo nixos-container run minecraft-server -- journalctl -u minecraft-server -f -n 100";
    };
  };
}
