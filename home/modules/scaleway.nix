{ pkgs, ... }:

let
  scalewaySecretPath = "home/Dev/scaleway/secret-key";
  wrappedScw = pkgs.runCommand "wrapped-scw"
    {
      buildInputs = [ pkgs.makeWrapper pkgs.scaleway-cli ];
    } ''
    mkdir -p $out/bin

    # This wrapper will inject the env var dynamically from pass at runtime
    cat > $out/bin/scw <<'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    # Load secret at runtime
    SCW_SECRET_KEY="$(pass show ${scalewaySecretPath} 2>/dev/null || true)"
    if [[ -z "$SCW_SECRET_KEY" ]]; then
      echo "Missing SCW_SECRET_KEY in pass (${scalewaySecretPath})" >&2
      exit 1
    fi

    export SCW_SECRET_KEY

    exec ${pkgs.scaleway-cli}/bin/scw "$@"
    EOF

    chmod +x $out/bin/scw
  '';
in
{
  home.packages = [ wrappedScw ];
}
