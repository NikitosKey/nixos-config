{ pkgs, config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      input-field = pkgs.lib.mkForce [
        {
          size = "250, 60";
          position = "0, -150"; # Твой отступ от челки
          
          # Используем цвета из Stylix
          outline_thickness = 2;
          outer_color = "rgb(${config.lib.stylix.colors.base05})"; 
          inner_color = "rgb(${config.lib.stylix.colors.base00})";
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          check_color = "rgb(${config.lib.stylix.colors.base0A})";
          fail_color = "rgb(${config.lib.stylix.colors.base08})";
          
          dots_center = true;
          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
        }
      ];
      
      label = [
        {
          text = "$TIME";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 86;
          position = "0, 75";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
  security.pam.services.hyprlock = {};
}
