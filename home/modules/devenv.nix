{ pkgs, ... }: {

  programs.direnv = {
    enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };
  home.packages = with pkgs; [
    devenv
  ];
}
