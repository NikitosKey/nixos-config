# ~/nixos-config/nixos/services/pipewire.nix
{
	services = {
		pulseaudio.enable = false;
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
			extraConfig.pipewire = {
				"context.properties" = {
					"default.clock.rate" = 48000;
					"default.clock.allowed-rates" = [ 48000 ];
				};
			};
		};
	};
}
