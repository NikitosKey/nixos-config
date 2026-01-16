{ pkgs, lib, ...}:
{
  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray;
  };
  systemd.services.v2raya = {
    environment = {
      V2RAY_LOCATION_ASSET = "/var/lib/v2raya";
      XRAY_LOCATION_ASSET = "/var/lib/v2raya";
    };

    # 2. Перед запуском копируем туда файлы, если их там нет или они битые
    preStart = lib.mkForce ''
      mkdir -p /var/lib/v2raya
      
      if [ ! -f /var/lib/v2raya/geosite.dat ]; then
        cp ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/v2raya/geosite.dat
        chmod 644 /var/lib/v2raya/geosite.dat
      fi
      
      if [ ! -f /var/lib/v2raya/geoip.dat ]; then
        cp ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/v2raya/geoip.dat
        chmod 644 /var/lib/v2raya/geoip.dat
      fi
    '';
  };
}
