{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ../common.nix
    ./fingerprint.nix
  ];

  # BIOS updates
  services.fwupd.enable = true;

  networking.hostName = "comet";
}
