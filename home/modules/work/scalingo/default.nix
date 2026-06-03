{
  lib,
  pkgs,
}:

pkgs.buildGoModule rec {
  pname = "scalingo";
  version = "1.41.0";

  src = pkgs.fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    # nix flake prefetch github:scalingo/cli/1.41.0 --json | jq .hash -r
    hash = "sha256-JP5sSE9xWAB9yVuFh74s85zh9y4t8f+VwUVmn6iMPFI=";
  };

  vendorHash = null;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeBuildInputs = [ pkgs.installShellFiles ];

  postInstall = ''
    rm $out/bin/dists
    installShellCompletion --cmd scalingo \
      --bash cmd/autocomplete/scripts/scalingo_complete.bash

    # Generate Zsh completion
    $out/bin/scalingo completion zsh > _scalingo
    install -Dm644 _scalingo $out/share/zsh/site-functions/_scalingo

    rm _scalingo
  '';

  meta = with lib; {
    description = "Command line client for the Scalingo PaaS";
    mainProgram = "scalingo";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
