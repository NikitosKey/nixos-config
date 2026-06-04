{ config, lib, pkgs, modulesPath, inputs, ... }:
let
  # Create a wrapper script that calls FEX wrapped inside muvm.
  # We use /run/wrappers/bin/muvm because the system wrapper has the 
  # necessary elevated capabilities/setuid to spawn the microVM.
  muvm-fex-wrapper = pkgs.writeShellScript "muvm-fex-wrapper" ''
    exec /run/wrappers/bin/muvm ${pkgs.fex}/bin/FEXInterpreter "$@"
  '';
in
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
    binfmt = {
      # emulatedSystems = [ "x86_64-linux" "i686-linux" ];
      registrations = {
        "x86_64-linux" = {
          magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
          interpreter = toString muvm-fex-wrapper;
          matchCredentials = true; 
          fixBinary = false;
        };
        "i686-linux" = {
          magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
          interpreter = toString muvm-fex-wrapper;
          matchCredentials = true;
          fixBinary = false;
        };
      };
    };
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
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    firewall = { 
      checkReversePath = false;
      trustedInterfaces = [ "lo" ];
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
		networkmanager = {
      enable = true;
      settings = {
        connectivity = {
          uri = "http://nmcheck.gnome.org/check_network_status.txt";
          interval = 300;
        };
      };
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
}
