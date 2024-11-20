{ ... }: {
  imports = [
    ../common.nix
    ../modules/shell.nix
    ../modules/security.nix
    ../modules/git.nix
    ../modules/editors.nix
    ../modules/work.nix
    ../modules/gnome.nix
    ../modules/devenv.nix
    ../modules/layout.nix
    ../modules/task.nix
  ];
}
