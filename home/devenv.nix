{ pkgs, ... }: {

  programs.direnv.enable = true;
  home.packages = with pkgs; [
    devenv
  ];

  programs.git.ignores = [
    ".devenv.flake.nix"
    "devenv.nix"
    ".devenv/"
    "devenv.lock"
    ".direnv/"
    ".envrc"
  ];

}
