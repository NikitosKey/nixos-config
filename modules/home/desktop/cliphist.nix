{
  services.cliphist = {

      enable = true;

      systemdTargets = ["config.wayland.systemd.target"];

      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
      allowImages = true;
    };
}
