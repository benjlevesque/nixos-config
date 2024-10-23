{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
    ];

    userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font Mono";

      "window.menuBarVisibility" = "toggle";
      "nixfmt.path" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
      "editor.formatOnSave" = true;
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
