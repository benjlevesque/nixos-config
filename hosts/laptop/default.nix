{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ../common.nix
    ./fingerprint.nix
  ];

  networking.hostName = "comet";
}
