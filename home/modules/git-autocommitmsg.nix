{ pkgs, ... }:
let
  git-autocommitmsg = pkgs.buildGoModule
    rec {
      pname = "git-autocommitmsg";
      version = "1.0.1";

      src = pkgs.fetchFromGitHub {
        owner = "benjlevesque";
        repo = "git-autocommitmsg";
        rev = version;
        hash = "sha256-P1orJ8SoVno8wZRvS2V/EsjkC9o54ozAdFknysxCXpY=";
      };
      vendorHash = "sha256-F1bK2dN5JQnnoee18BvDARFQQf90HLftjIXNf/brY8c=";
      ldflags = [
        "-X 'main.version=${version}'"
        "-X 'main.commit=${src.rev}'"
      ];

    };
in
{
  home.packages = [
    git-autocommitmsg
  ];
}
