{ ... }: {
  imports = [
    ../common.nix
    ../modules/shell.nix
    ../modules/gnome.nix
    ../modules/security.nix
    ../modules/git.nix
    ../modules/editors.nix
  ];
}
