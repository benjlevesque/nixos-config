{ pkgs, ... }: {
  home.packages = with pkgs; [
    mattermost-desktop
    scalingo
  ];
  
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = ["Mattermost.desktop"];
    };
  };
}
