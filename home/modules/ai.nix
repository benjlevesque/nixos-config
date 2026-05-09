{ pkgs, unstable, ... }:
let
  agent-vm-script = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/sylvinus/agent-vm/main/agent-vm.sh";
    sha256 = "08r1jdhidagg1jp4m7hxgk52ks1m1kffnxj75gq4snbr02bds724";
  };

  agent-vm = pkgs.writeShellScriptBin "agent-vm" ''
    set -euo pipefail
    source ${agent-vm-script}
    agent-vm "$@"
  '';
in
{
  home.packages = [
    unstable.lima
    agent-vm
  ];
}
