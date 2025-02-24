{ pkgs, ... }:
let
  git-rename-branch = pkgs.buildGoModule
    rec {
      pname = "git-rename-branch";
      version = "1.0.1";

      src = pkgs.fetchFromGitHub {
        owner = "benjlevesque";
        repo = "git-rename-branch";
        rev = version;
        hash = "sha256-MTiRn16uwOmvtXnN+O20nB+wEWKyXSnU1y9obJ5PD1c=";
      };
      vendorHash = null;
      ldflags = [
        "-X 'main.version=${version}'"
        "-X 'main.commit=${src.rev}'"
      ];

    };
in
{
  home.packages = [
    git-rename-branch
  ];
}
