{ config
, lib
, pkgs
, ...
}:

{
  home.packages = with pkgs; [
    xsel
  ];

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

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "amuse";
    };
    initContent = ''
      if command -v tmux >/dev/null 2>&1; then
        if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && [[ -n "$PS1" ]]; then
          exec tmux
        fi
      fi
      # Bind Ctrl-Backspace to delete previous word, and Ctrl+Suppr to delete next word
      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word

      # source fzf-git-sh
      [ -f ${pkgs.fzf-git-sh}/share/fzf-git.sh ] && source ${pkgs.fzf-git-sh}/share/fzf-git.sh
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
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Replaces `cd`
  # https://github.com/ajeetdsouza/zoxide
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Replaces `ls`
  # https://github.com/lsd-rs/lsd
  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Aliases
  home.shellAliases = {
    rebuild-nix = "nixos-rebuild --flake ~/.nixos --use-remote-sudo switch";
    rebuild-hm = "${pkgs.home-manager}/bin/home-manager switch --option eval-cache false  --flake $\"($env.HOME)/.nixos#($env.USER)@(hostname)\"";
    # navigation
    "~" = "cd";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };

  programs.alacritty = { enable = true; };

  programs.tmux = {
    enable = true;
    clock24 = true;
    sensibleOnTop = true;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-Space";
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Split windows with | and -
      bind '\' split-window -h -c "#{pane_current_path}"
      bind 'h' split-window -h -c "#{pane_current_path}"

      bind '-' split-window -v -c "#{pane_current_path}"
      bind 'v' split-window -v -c "#{pane_current_path}"

      # Yank keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Set window name
      set -g default-terminal "tmux-256color"
      set -g renumber-windows on

      # Full screen
      bind f resize-pane -Z

      # Alt+number navigation 
      bind -n M-1 select-window -t :1
      bind -n M-2 select-window -t :2
      bind -n M-3 select-window -t :3
      bind -n M-4 select-window -t :4
      bind -n M-5 select-window -t :5
      bind -n M-6 select-window -t :6
      bind -n M-7 select-window -t :7
      bind -n M-8 select-window -t :8
      bind -n M-9 select-window -t :9
    '';

    plugins = with pkgs.tmuxPlugins; [
      yank
      better-mouse-mode
      {
        plugin = catppuccin;
        extraConfig = ''
          set -ogq @catppuccin_window_text " #W"
          set -ogq @catppuccin_window_current_text " #W"

        '';
      }
    ];
  };

  programs.bat.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}

