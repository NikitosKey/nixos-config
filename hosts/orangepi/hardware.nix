{ pkgs, lib, ... }:
{
  imports = [
    ./disko.nix
  ];

  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible = {
        enable = lib.mkForce true;
        useGenerationDeviceTree = true;
      };
    };
    kernelParams = [ "clk_ignore_unused" "rockchip_suspend.mem_type=0" ];
    initrd.availableKernelModules = [ "nvme" "dm_crypt" "dm_mod" "btrfs" ];
  };
  virtualisation.docker.storageDriver = "btrfs";

	networking = {
	  nameservers = [ "8.8.8.8" "1.1.1.1" ];
		hostName = "orangepi";
    networkmanager = {
      enable = true;
      wifi.macAddress = "preserve";
      settings = {
        main = {
          rc-manager = "resolvconf";
        };
      };
      dns = "systemd-resolved";
    };
  };

  zramSwap.enable = true;

  services.fstrim.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
