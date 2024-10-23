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
      bind -s 'set completion-ignore-case on'
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
      # Ctrl-Backspace
      "\\C-H" = "backward-kill-word";
      # arrow up
      "\\e[A" = "history-search-backward";
      # arrow down
      "\\e[B" = "history-search-forward";
    };
  };

  # prompt customization
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

  # Replaces `cd`
  # https://github.com/ajeetdsouza/zoxide
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  # Replaces `ls`
  # https://github.com/lsd-rs/lsd
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # Aliases
  home.shellAliases =
    {
      rebuild-nix = "nixos-rebuild --flake ~/.nixos --use-remote-sudo switch";
      rebuild-hm = "${pkgs.home-manager}/bin/home-manager switch --option eval-cache false  --flake $HOME/.nixos#benji";
      # navigation
      "~" = "cd";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
}
