{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    gnomeExtensions.clipboard-history
    gnome-sound-recorder
  ];

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
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Primary><Alt>t";
        command = "kgx";
        name = "open-terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Shift><Control>Escape";
        command = "gnome-system-monitor";
        name = "open-monitor";
      };

      "org/gtk/settings/file-chooser" = {
        show-hidden = true;
      };

    };
  };
}
