{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pass
    wl-clipboard
  ];

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.gpg.enable = true;
}
