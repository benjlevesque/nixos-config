{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    bitwarden-cli
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    maxCacheTtl = 4 * 60 * 60; # 4 hours
    defaultCacheTtl = 1 * 60 * 60; # 1 hour
  };

  programs.gpg.enable = true;
  programs.password-store.enable = true;

  programs.browserpass = {
    enable = true;
    browsers = [
      "firefox"
    ];
  };

  # Custom fzf completion for `pass` (password-store)
  # https://sim590.github.io/fr/outils/fzf/#pass-passwordstore
  programs.zsh.initContent = ''
    # fzf completion for pass
    _fzf_complete_pass() {
      ARGS="$@"
      _fzf_complete "" "$@" < <(
        command find ~/.password-store/ -name "*.gpg" | sed -r 's,(.*)\.password-store/(.*)\.gpg,\2,'
      )
    }
  '';
}
