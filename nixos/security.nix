{ pkgs, self, ... }:
{
  security = {
    # for pipewire
		rtkit.enable = true;
		wrappers = {
			v2rayN = {
				source = "${pkgs.v2rayn}/bin/v2rayN";
				owner = "root";
				group = "root";
				capabilities = "cap_net_admin,cap_net_bind_service+ep";
			};
		};
	};
}
