{ lib, pkgs, ... }:
pkgs.buildGoModule rec {
  pname = "gonzo";
  version = "0.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    rev = "v${version}";
    sha256 = "sha256-P8Ntt8Dj5zq+Ff5MkZEvWabk2w5Cm6tXxl3ssMxDNok=";
  };

  vendorHash = "sha256-XKwtq8EF774lHLHtyFzveFa5agJa15CvhsuwwaQdJwU=";

  meta = with lib; {
    description = "A Go package from control-theory";
    homepage = "https://github.com/control-theory/gonzo";
    license = licenses.mit;
    maintainers = [ ];
  };
}
