{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./shell.nix
    ./editors.nix
    ./git.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "benji";
  home.homeDirectory = "/home/benji";
  home.shellAliases = {
    rebuild-nix = "nixos-rebuild --flake ~/.nixos --use-remote-sudo switch";
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    htop
    chezmoi
    pass
    nixfmt-rfc-style
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #home.activation.chezmoi = lib.hm.dag.entryAfter ["installPackages"] ''
  #  PATH="${pkgs.chezmoi}/bin:${pkgs.git}/bin:${pkgs.git-lfs}/bin:''${PATH}"
  #  
  #  ssh-keyscan github.com >> ~/.ssh/known_hosts
  #
  #  $DRY_RUN_CMD chezmoi init benjlevesque --ssh
  #  $DRY_RUN_CMD chezmoi update -a
  #   $DRY_RUN_CMD chezmoi git status
  #'';

}
