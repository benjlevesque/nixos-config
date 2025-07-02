{ pkgs, ... }: {

  programs.direnv = {
    enable = true;
    config = {
      global.hide_env_diff = true;
    };
    enableNushellIntegration = true;
  };
  home.packages = with pkgs; [
    devenv
  ];
}
