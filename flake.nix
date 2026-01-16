# ~/nixos-config/flake.nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-mesa.url = "github:NixOS/nixpkgs/c5ae371f1a6a7fd27823";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
        url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs-mesa";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, apple-silicon, nixvim, stylix, ... }@inputs: 
    let
      system = "aarch64-linux";
      
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in 
  {
    nixosConfigurations = {
      macbookpro = nixpkgs.lib.nixosSystem {
        # stdenv.HostPlatfotm.system = "aarch64-linux";
        inherit system;
        specialArgs = { inherit inputs apple-silicon self; };
        modules = [
          apple-silicon.nixosModules.default
          ./hosts/macbookpro/configuration.nix
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ overlay-unstable ]; }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.nikitoskey = {
              imports = [
               ./user
              ];
            };
            home-manager.backupFileExtension = "bkg";
          }
        ];
      };
      orangepi = nixpkgs.lib.nixosSystem {
        # stdenv.HostPlatfotm.system = "aarch64-linux";
        inherit system;
        specialArgs = { inherit inputs apple-silicon self; };
        modules = [
          ./hosts/orangepi5ultra/configuration.nix
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ overlay-unstable ]; }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.nikitoskey = {
              imports = [
               ./user
               nixvim.homeModules.nixvim
              ];
            };
            home-manager.backupFileExtension = "bkg";
          }
        ];
      };
    };
  };
}
