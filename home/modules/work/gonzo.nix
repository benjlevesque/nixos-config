{ lib, pkgs, ... }:
pkgs.buildGoModule rec {
  pname = "gonzo";
  version = "0.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    rev = "v${version}";
    sha256 = lib.fakeSha256;
  };

  vendorHash = lib.fakeSha256;

  meta = with lib; {
    description = "A Go package from control-theory";
    homepage = "https://github.com/control-theory/gonzo";
    license = licenses.unfree; # Update with correct license
    maintainers = [ ];
  };
}
