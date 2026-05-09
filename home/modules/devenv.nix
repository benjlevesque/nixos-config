{ pkgs, unstable, ... }: {

  programs.direnv = {
    enable = true;
    config = {
      global.hide_env_diff = true;
    };
    enableBashIntegration = true;
  };
  home.packages = with pkgs; [
    unstable.devenv
    nix-prefetch-git
  ];
}
