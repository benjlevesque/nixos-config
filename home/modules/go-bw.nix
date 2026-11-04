{ pkgs, ... }:
let
  go-bw = pkgs.buildGoModule rec {
    pname = "go-bw";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "benjlevesque";
      repo = "go-bw";
      rev = "9217f2d2116479e3a87b8bec70038655cc993da1";
      hash = "sha256-eIdNv3jm950loZOzRcraaCTTeMpoN+oS6lAS2o9No2w=";
    };
    vendorHash = "sha256-f3MgFUve0aE6safxyLrj8VxdAXMy+kqU2HOFnClB29E=";
    ldflags = [
      "-X 'main.version=${version}'"
      "-X 'main.commit=${src.rev}'"
    ];

  };
in
{
  home.packages = [
    go-bw
  ];
}
