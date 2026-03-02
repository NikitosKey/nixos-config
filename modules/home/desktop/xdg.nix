{
  xdg.desktopEntries = {
    dos-vm = {
      name = "DOS VM";
      genericName = "Emulator";
      exec = "qemu-system-i386 -drive file=\"/home/nikitoskey/VMs/DOS_2.qcow2\"";
      terminal = false;
      categories = [ "Application" "Game" ];
    };
  };
}
