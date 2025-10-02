{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "s3";
  src = ./.;
  runtimeInputs = [ pkgs.s3cmd ];
  nativeBuildInputs = [ pkgs.installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/s3.sh $out/bin/s3
    chmod +x $out/bin/s3

    installShellCompletion --cmd s3 \
      --bash  $src/s3.completion.bash \
      --zsh  $src/s3.completion.zsh
  '';
}
