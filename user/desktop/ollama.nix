{ pkgs, lib, ... }:{
  services.ollama = {
    enable = true;
    package = lib.mkDefault pkgs.unstable.ollama-vulkan;
  };
}
