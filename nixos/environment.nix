{
  environment = {
		loginShellInit = ''
    	# Запускаем Hyprland на первом TTY
    	if [ "$(tty)" = "/dev/tty1" ]; then
      	exec Hyprland
    	fi
  	'';
	};
}
