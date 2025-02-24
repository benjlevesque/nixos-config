{ pkgs, ... }:
let
  task = pkgs.buildGoModule
    rec {
      pname = "task";
      version = "0.2.2";

      src = pkgs.fetchFromGitHub {
        owner = "benjlevesque";
        repo = "task";
        rev = version;
        hash = "sha256-hxLDAL3D8lDjDTrBzuQbPZsPAOxHx0o5RJodfttbUHU=";
      };
      vendorHash = "sha256-G5ecTgOSwXOE8zaiPTWVlZkZ4Zic0xG+5velCIHXrjk=";
      ldflags = [
        "-X 'main.version=${version}'"
      ];

      nativeBuildInputs = with pkgs; [
        installShellFiles
      ];

      # Install shell completions
      postInstall = ''
        installShellCompletion --cmd task \
          --bash <($out/bin/task completion bash) \
          --fish <($out/bin/task completion fish) \
          --zsh <($out/bin/task completion zsh)
      '';
    };
in
{
  home.packages = [
    task
  ];
}
