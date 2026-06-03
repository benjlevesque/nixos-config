{ ... }:
{
  imports = [
    ../common.nix
    ../modules/ai.nix
    ../modules/shell.nix
    ../modules/security.nix
    ../modules/git.nix
    ../modules/editors.nix
    ../modules/work
    ../modules/gnome.nix
    ../modules/devenv.nix
    ../modules/layout.nix
    ../modules/task.nix
    ../modules/git-rename-branch.nix
    ../modules/git-autocommitmsg.nix
    # re-enable when build passes
    #../modules/scaleway.nix
    ../modules/media.nix
  ];
}
