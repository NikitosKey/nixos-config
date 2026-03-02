{ osConfig, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Nikita Morozov";
        email = "${osConfig.myOptions.email}";
      };
    };
  };
}
