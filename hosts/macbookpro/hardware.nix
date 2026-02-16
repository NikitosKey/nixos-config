{ config, lib, pkgs, modulesPath, inputs, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix") 
    ];

  boot = {
    consoleLogLevel = 0;
    initrd = {
      availableKernelModules = [ "usb_storage" "sdhci_pci" "uas" "usbhid" "xhci_pci"];
      kernelModules = [ "tun" "fuse" "dm_snapshot"];
    };
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.all.rp_filter" = 2;
    };
    kernelModules = [ ];
    kernelParams = [
      "appledrm.show_notch=1" 
      "appledrm.unstable_edid=1"
      "appledrm.vrr_hack=1"
    ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
    };
    # binfmt.emulatedSystems = [ "x86_64-linux" "i686-linux" ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  
	hardware = {
		asahi = {
			peripheralFirmwareDirectory = ./firmware;
		};
		graphics = {
      enable = true;
      extraPackages = [
        pkgs.mesa.opencl
      ];
    };
    bluetooth.enable = true;
	};

  services.resolved.enable = true;

	networking = {
		hostName = "macbookpro";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    firewall = { 
      checkReversePath = false;
      trustedInterfaces = [ "lo" ];
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
      # extraCommands = ''
      #   iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300
      #   iptables -t mangle -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300
      # '';
    };
		networkmanager = {
      enable = true;
      wifi.macAddress = "preserve";
      settings = {
        connectivity = {
          uri = "http://nmcheck.gnome.org/check_network_status.txt";
          interval = 300;
        };
        main = {
          rc-manager = "resolvconf";
        };
      };
      dns = "systemd-resolved";
    };
	};

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/08405f9b-dec5-489b-a862-173e10c9a989";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8722-1E01";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # swapDevices = [ {
  #   device = "/var/lib/swapfile";
  #   size = 16 * 1024;
  # } ];
}
