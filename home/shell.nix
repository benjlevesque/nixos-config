{ config
, lib
, pkgs
, ...
}:

{
  programs.gnome-terminal.profile.default.font = "FiraCode Nerd Font Mono";

  programs.bash = {
    enable = true;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    bashrcExtra = ''
      bind '"\t":menu-complete'
    '';
  };

  programs.readline = {
    enable = true;
    variables = {
      show-all-if-ambiguous = true;
      colored-completion-prefix = true;
      colored-stats = true;
      menu-complete-display-prefix = true;
      bind-tty-special-chars = false;
    };

    bindings = {
      "\\C-w" = "backward-kill-word";
      ## arrow up
      "\\e[A" = "history-search-backward";
      ## arrow down
      "\\e[B" = "history-search-forward";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.term = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
}
