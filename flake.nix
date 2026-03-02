# ~/nixos-config/flake.nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-mesa.url = "github:NixOS/nixpkgs/c5ae371f1a6a7fd27823";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    nixpkgs-custom.url = "github:NikitosKey/nixpkgs/lmstudio-aarch64";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rk3588.url = "github:NikitosKey/nixos-rk3588/orangepi5ultra";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    apple-silicon,
    rk3588,
    disko,
    ...
  }@inputs:
    let
      mkSystem = import ./modules/system.nix { inherit inputs self; };
    in {
    nixosConfigurations =  {
        macbookpro = mkSystem {
          hostname = "macbookpro";
          isLaptop = true;
          isDesktop = true;
          extraModules = [
            apple-silicon.nixosModules.default
          ];
        };

        orangepi = mkSystem {
          hostname = "orangepi";
          isServer = true;
          extraModules = [
            disko.nixosModules.disko
            rk3588.nixosModules.orangepi5ultra
          ];
        };
     };
  };
}
