{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ./keyboard.nix
  ];

  networking.hostName = "nimbus";
}
