{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./shell.nix
    ./editors.nix
    ./git.nix
    ./security.nix
  ];

  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "benji";
  home.homeDirectory = "/home/benji";
  home.shellAliases =
    {
      rebuild-nix = "nixos-rebuild --flake ~/.nixos --use-remote-sudo switch";
      rebuild-hm = "${pkgs.home-manager}/bin/home-manager switch --option eval-cache false  --flake $HOME/.nixos#benji";
      # navigation
      "~" = "cd";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    htop
    keyd
    devenv
    httpie
    jq
    gnomeExtensions.clipboard-history
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

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          pkgs.gnomeExtensions.clipboard-history.extensionUuid
          pkgs.gnomeExtensions.auto-move-windows.extensionUuid
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
        ];
        favorite-apps = [ "firefox.desktop" "org.gnome.Console.desktop" "org.gnome.Nautilus.desktop" "code.desktop" ];
      };

      "org/gnome/shell/extensions/auto-move-windows" = {
        application-list = [ "firefox.desktop:1" "code.desktop:2" ];
      };

      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      "org/gnome/mutter" = { edge-tiling = true; };


      "org/gnome/desktop/input-sources" = {
        sources = [ (lib.gvariant.mkTuple [ "xkb" "us+alt-intl" ]) ];
      };


      # unused, just to "free" <Super>v an use it on clipboard-history
      "org/gnome/shell/keybindings" = { toggle-message-tray = [ "<Control><Super>v" ]; };
      "org/gnome/shell/extensions/clipboard-history" = { toggle-menu = [ "<Super>v" ]; };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Primary><Alt>t";
        command = "kgx";
        name = "open-terminal";
      };
    };
  };

}
