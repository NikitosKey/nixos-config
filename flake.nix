# ~/nixos-config/flake.nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-mesa.url = "github:NixOS/nixpkgs/c5ae371f1a6a7fd27823";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";

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
    nixpkgs, 
    nixpkgs-stable, 
    nixpkgs-unstable, 
    home-manager, 
    apple-silicon, 
    nixvim, 
    stylix,
    rk3588,
    disko,
    ... 
  }@inputs: 
    let
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
      mkSystem = { hostname, extraModules ? [] }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          { 
            networking.hostName = hostname;
            nixpkgs.overlays = [ overlay-unstable overlay-stable ];
          }
          ./system
          ./hosts/${hostname}/configuration.nix
          ./hosts/${hostname}/hardware.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs self; };
            home-manager.users.nikitoskey = import ./user; 
            home-manager.backupFileExtension = "bkg";
          }
        ] ++ extraModules;
      };
    in {
    nixosConfigurations =  {
        macbookpro = mkSystem {
          hostname = "macbookpro";
          extraModules = [
            apple-silicon.nixosModules.default
            ./system/desktop
            ./system/desktop/asahi-battery.nix
            ./system/desktop/ios.nix
            { home-manager.users.nikitoskey = import ./user/desktop; }
          ];
        };

        orangepi = mkSystem {
          hostname = "orangepi";
          extraModules = [
            disko.nixosModules.disko
            ./hosts/orangepi/disko.nix
            rk3588.nixosModules.orangepi5ultra
            { home-manager.users.nikitoskey = import ./user/terminal; }
          ];
        };
     };
  };
}
