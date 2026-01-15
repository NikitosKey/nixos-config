{ pkgs, self, ... }:
{
  security = {
    # for pipewire
		rtkit.enable = true;
    pam.services.hyprlock = {};
	};
}
