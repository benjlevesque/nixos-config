{ pkgs, ... }: {
  home.packages = with pkgs; [
    mattermost-desktop
    scalingo
    clever-tools
    s3cmd
  ];
  
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = ["Mattermost.desktop"];
    };
  };
}
