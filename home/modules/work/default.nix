{ pkgs, lib, ... }:
let
  s3 = import ./s3 { inherit pkgs; };
  scalingo = import ./scalingo { inherit lib pkgs; };
  gonzo = import ./gonzo.nix { inherit lib pkgs; };
in
{
  home.packages = [
    pkgs.mattermost-desktop
    pkgs.clever-tools
    pkgs.onlyoffice-desktopeditors
    pkgs.s3cmd
    s3
    scalingo
    pkgs.thunderbird-latest-unwrapped
    gonzo
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "Mattermost.desktop" ];
    };
  };
}
