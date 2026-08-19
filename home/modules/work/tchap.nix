# from https://github.com/tchapgouv/tchap-desktop/pull/161/files
{
  lib,
  pkgs,
}:

let
  # Copied from https://github.com/tchapgouv/tchap-desktop/blob/master/package.json
  tchapWebMeta = {
    version = "4.18.3";
    archiveName = "tchap-4.18.3-prod-20260106.tar.gz";
    repo = "https://github.com/tchapgouv/tchap-web-v4";
  };

  # Télécharger l'archive tchap-web de manière pure
  tchapWebArchive = pkgs.fetchurl {
    url = "${tchapWebMeta.repo}/releases/download/tchap-${tchapWebMeta.version}/${tchapWebMeta.archiveName}";
    hash = "sha256-rp1CoJyJC0faSe/QkfxGHeFGMP8GO0pGIs1cdtEUPaE="; # À remplir après la première tentative
  };

in
pkgs.rustPlatform.buildRustPackage rec {
  pname = "tchap-desktop";
  inherit (tchapWebMeta) version;

  src = pkgs.fetchFromGitHub {
    owner = "tchapgouv";
    repo = "tchap-desktop";
    rev = "tchap-${version}";
    hash = "sha256-iroiJvQ8r8Dd+DQrLYeXRMHeEYZaQu8dIH0zoh1YqDE="; # À remplir avec: nix-prefetch-url --unpack https://github.com/tchapgouv/tchap-desktop/archive/refs/tags/tchap-${version}.tar.gz
  };

  # Dépendances npm (à la racine du projet)
  npmDeps = pkgs.fetchNpmDeps {
    src = "${src}";
    hash = "sha256-4wLw6jFEny2OPtGqf9UEkEy29LwOczSHusiUgQSoaKA="; # À remplir après la première tentative de build
  };

  # Le code Rust est dans src-tauri
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-alf+8byB1HoZNQf9tMMRSNsX5JxlR/uVm8bgbjOxYnc="; # À remplir avec le hash après la première tentative de build

  # Phase de préparation
  postPatch = ''
    # Placer l'archive tchap-web pré-téléchargée au bon endroit
    mkdir -p archives
    cp ${tchapWebArchive} archives/${tchapWebMeta.archiveName}
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  ''
  # NOTE: libayatana should use pkg-config…
  + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    indicatorFile="$(find "$cargoDepsCopy" -path '*/libappindicator-sys-*/src/lib.rs' -print -quit || true)"
    if [ -n "$indicatorFile" ]; then
      substituteInPlace "$indicatorFile" \
        --replace "libayatana-appindicator3.so.1" "${pkgs.libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    fi
  '';

  preConfigure = ''
    # Les dépendances npm sont déjà installées par npmConfigHook

    # "Télécharger" l'archive (en fait déjà présente)
    npm run fetch-package -- prod || true

    # Si le script a échoué, extraire manuellement l'archive
    if [ ! -d "src" ]; then
      mkdir -p src
      tar -xzf archives/${tchapWebMeta.archiveName} -C src --strip-components=1
    fi
  '';

  nativeBuildInputs = with pkgs; [
    cargo-tauri.hook
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    makeBinaryWrapper
    jq
    moreutils
  ];

  buildInputs =
    with pkgs;
    [
      openssl
      sqlcipher
      webkitgtk_4_1
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      librsvg
      libsoup_3
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libayatana-appindicator
      wrapGAppsHook3
      desktop-file-utils
    ];

  # Nécessaire pour tauri-plugin-deep-link.
  # GIO_EXTRA_MODULES est nécessaire pour avoir le support TLS.
  # https://github.com/tauri-apps/tauri/issues/11647
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ pkgs.desktop-file-utils ]}"
      --prefix GIO_EXTRA_MODULES : ${pkgs.glib-networking}/lib/gio/modules
    )
  '';

  # Variables d'environnement
  env = {
    # Pour sqlcipher
    SQLCIPHER_LIB_DIR = "${pkgs.sqlcipher}/lib";
    SQLCIPHER_INCLUDE_DIR = "${pkgs.sqlcipher}/include";
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    LIBRARY_PATH = "${pkgs.sqlcipher}/lib";
    C_INCLUDE_PATH = "${pkgs.sqlcipher}/include";
  };

  # Désactiver les tests (pas de tests dans ce projet)
  doCheck = false;

  # Phase d'installation
  postInstall = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    rm -f $out/share/applications/Tchap.desktop
    # Les icônes sont dans src-tauri/icons depuis la racine
    install -Dm644 src-tauri/icons/icon.png $out/share/icons/hicolor/128x128/apps/tchap.png

    # Créer le fichier .desktop
    mkdir -p $out/share/applications
    cat > $out/share/applications/tchap.desktop <<EOF
    [Desktop Entry]
    Name=Tchap
    Comment=Messagerie instantanée du secteur public français
    Exec=$out/bin/tchap-desktop %u
    Icon=tchap
    Type=Application
    Categories=Network;InstantMessaging;
    MimeType=x-scheme-handler/tchap
    EOF
  '';

  meta = with lib; {
    description = "Application de bureau Tchap - Messagerie du secteur public français";
    homepage = "https://github.com/tchapgouv/tchap-desktop";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "tchap-desktop";
  };
}
