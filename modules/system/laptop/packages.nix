{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Laptop-specific tools (e.g. power management diagnostics)
    # acpi
    # powertop
  ];
}
