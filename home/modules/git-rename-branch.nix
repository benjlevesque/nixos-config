{ pkgs, ... }:
let
  git-rename-branch = pkgs.buildGoModule
    rec {
      pname = "git-rename-branch";
      version = "1.0.2";

      src = pkgs.fetchFromGitHub {
        owner = "benjlevesque";
        repo = "git-rename-branch";
        rev = version;
        hash = "sha256-t/6zt1gsB/bzl6a627l5pJUSuzUDj/7WdExp0Aoyalo=";
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
