{ pkgs, lib, ... }: {

  imports = [
    ./disko.nix
  ];

  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };

    kernelParams = [ "clk_ignore_unused" "rockchip_suspend.mem_type=0" ];
    initrd.availableKernelModules = [ "nvme" "dm_crypt" "dm_mod" "btrfs" ];
  };
  virtualisation.docker.storageDriver = "btrfs";

	networking = {
		hostName = "orangepi";
  };
}
