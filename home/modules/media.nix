{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    qbittorrent
  ];
  # vlc remote
  # networking.firewall.allowedTCPPorts = [ 4212 ];
}
