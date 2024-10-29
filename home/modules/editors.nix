{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      jnoortheen.nix-ide
    ];

    userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font Mono";

      "window.menuBarVisibility" = "toggle";
      "editor.formatOnSave" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        nil = {
          formatting = {
            command = [ "nixpkgs-fmt" ];
          };
        };
      };
      "scm.defaultViewMode" = "tree";
      "terminal.integrated.defaultProfile.linux" = null;
      "terminal.integrated.shell.linux" = {
        bash = "/run/current-system/sw/bin/bash";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };

}
