{ inputs, self, ... }:

{ hostname, extraModules ? [], isDesktop ? false, isLaptop ? false, isServer ? false }:

inputs.nixpkgs.lib.nixosSystem {
  # Pass roles to specialArgs so they can be used in conditional imports
  specialArgs = { inherit inputs self isDesktop isLaptop isServer; };

  modules = [
    # Main module bundle (imports options, presets, system modules)
    ./default.nix

    # Host specific configuration
    ../hosts/${hostname}/configuration.nix

    # External modules
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager

    # Home Manager configuration
    ({ config, ... }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs self isDesktop isLaptop isServer; };
        backupFileExtension = "bkg";
        users.${config.myOptions.username} = import ./home/default.nix;
      };
    })

    # System overlays and networking
    {
      networking.hostName = hostname;
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
          stable = import inputs.nixpkgs-stable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
          custom = import inputs.nixpkgs-custom {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
      ];
    }
  ] ++ extraModules;
}
