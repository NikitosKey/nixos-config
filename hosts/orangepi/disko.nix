# hosts/orangepi/disko.nix
# {
#   disko.devices = {
#     disk = {
#       main = {
#         type = "disk";
#         device = "/dev/nvme0n1";
#         content = {
#           type = "gpt";
#           partitions = {
#             boot = {
#               size = "1G";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#                 mountpoint = "/boot";
#               };
#             };
#             luks = {
#               size = "100%";
#               content = {
#                 type = "luks";
#                 name = "crypted";
#                 settings.allowDiscards = true;
#                 content = {
#                   type = "btrfs";
#                   extraArgs = [ "-f" ];
#                   subvolumes = {
#                     "@" = {
#                       mountpoint = "/";
#                       mountOptions = [ "compress=zstd" "noatime" ];
#                     };
#                     "@home" = {
#                       mountpoint = "/home";
#                       mountOptions = [ "compress=zstd" ];
#                     };
#                     "@nix" = {
#                       mountpoint = "/nix";
#                       mountOptions = [ "compress=zstd" "noatime" ];
#                     };
#                     "@log" = {
#                       mountpoint = "/var/log";
#                       mountOptions = [ "compress=zstd" "noatime" ];
#                     };
#                   };
#                 };
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
