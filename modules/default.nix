{ lib, isDesktop ? false, isLaptop ? false, isServer ? false, ... }:

with lib;

{
  imports = [
    ./options.nix
    ./system/common
  ]
    ++ (optionals isDesktop [ ./system/desktop ])
    ++ (optionals isLaptop [ ./system/laptop ])
    ++ (optionals isServer [ ./system/server ]);
}
