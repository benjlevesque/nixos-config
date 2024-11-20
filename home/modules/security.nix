{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pass
    wl-clipboard
  ];

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    maxCacheTtl = 4 * 60 * 60; # 4 hours
    defaultCacheTtl = 1 * 60 * 60; # 1 hour
  };

  programs.gpg.enable = true;
  programs.browserpass = {
    enable = true;
    browsers = [
      "firefox"
    ];
  };
}
