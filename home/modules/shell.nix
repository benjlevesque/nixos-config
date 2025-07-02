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

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      buffer_editor = "nvim";
      history = {
        file_format = "sqlite";
        isolation = true;
      };
    };
    extraConfig = ''
      $env.DOCKER_HOST = $"unix://($env.XDG_RUNTIME_DIR)/docker.sock"
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
    enableNushellIntegration = true;
  };

  # Replaces `cd`
  # https://github.com/ajeetdsouza/zoxide
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Replaces `ls`
  # https://github.com/lsd-rs/lsd
  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
  };

  # Aliases
  home.shellAliases =
    {
      rebuild-nix = "nixos-rebuild --flake ~/.nixos --use-remote-sudo switch";
      rebuild-hm = "${pkgs.home-manager}/bin/home-manager switch --option eval-cache false  --flake $HOME/.nixos#$USER@$(hostname)";
      # navigation
      "~" = "cd";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
}

