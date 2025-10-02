{ pkgs, lib, unstable, ... }:
let
  s3 = import ./s3 { inherit pkgs; };
in
{
  home.packages = [
    pkgs.mattermost-desktop
    pkgs.clever-tools
    pkgs.onlyoffice-bin
    pkgs.s3cmd
    s3
    unstable.scalingo
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [ "Mattermost.desktop" ];
    };
  };
}
