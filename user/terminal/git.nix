# ~/nixos-config/home-manager/cli/git.nix
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Nikita Morozov";
        email = "nikitwww@gmail.com";
      };
    };
  };
}
