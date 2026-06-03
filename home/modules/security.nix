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
    enableSshSupport = true;
  };

  programs.gpg.enable = true;
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { };
  };

  programs.browserpass = {
    enable = true;
    browsers = [
      "firefox"
    ];
  };

  programs.zsh.initContent = ''
    # Using gpg-agent as ssh-agent
    # https://medium.com/@chrispisano/ssh-authentication-with-gpg-411676781647 
    unset SSH_AGENT_PID
    if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi

    # Custom fzf completion for `pass` (password-store)
    # https://sim590.github.io/fr/outils/fzf/#pass-passwordstore
    _fzf_complete_pass() {
      ARGS="$@"
      PASS_PATH="''${PASSWORD_STORE_DIR:-$HOME/.password-store}"
      _fzf_complete "" "$@" < <(
        command find "$PASS_PATH" -name "*.gpg" | sed -r "s,$PASS_PATH/(.*)\.gpg,\1,"
      )
    }
  '';

}
