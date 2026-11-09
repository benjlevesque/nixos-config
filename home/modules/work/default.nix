{ pkgs, lib, ... }:
let
  s3 = import ./s3 { inherit pkgs; };
  # scalingo = import ./scalingo { inherit lib pkgs; };
  gonzo = import ./gonzo.nix { inherit lib pkgs; };
  tchap = import ./tchap.nix { inherit lib pkgs; };
in
{
  home.packages = [
    pkgs.mattermost-desktop
    pkgs.clever-tools
    pkgs.onlyoffice-desktopeditors
    pkgs.s3cmd
    s3
    pkgs.scalingo
    pkgs.thunderbird-latest-unwrapped
    gonzo
    tchap
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "tchap.desktop"
        "Mattermost.desktop"
      ];
    };
  };
}
