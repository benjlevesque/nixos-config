{ pkgs, ... }: {

  programs.direnv = {
    enable = true;
    config = {
      global.hide_env_diff = true;
    };
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };
  home.packages = with pkgs; [
    devenv
    nix-prefetch-git
  ];
}
