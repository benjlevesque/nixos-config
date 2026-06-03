{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ../common.nix
    ./fingerprint.nix
    ./fix-swap-encryption.nix

  ];

  # BIOS updates
  services.fwupd.enable = true;

  networking.hostName = "comet";

  services.tailscale.enable = true;
}
