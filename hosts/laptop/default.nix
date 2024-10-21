{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ./fingerprint.nix
  ];

  networking.hostName = "comet";
}
