{ pkgs, unstable, inputs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];


  programs.vscode = {
    enable = true;
    package = unstable.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        jnoortheen.nix-ide
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-toggle-quotes";
          publisher = "BriteSnow";
          version = "0.3.6";
          sha256 = "Hn3Mk224ePAAnNtkhKMcCil/kTgbonweb1i884Q62rs=";
        }
        {
          name = "sqltools";
          publisher = "mtxr";
          version = "0.28.3";
          sha256 = "bTrHAhj8uwzRIImziKsOizZf8+k3t+VrkOeZrFx7SH8=";
        }
        {
          name = "sqltools-driver-pg";
          publisher = "mtxr";
          version = "0.5.4";
          sha256 = "XnPTMFNgMGT2tJe8WlmhMB3DluvMZx9Ee2w7xMCzLYM=";
        }
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
        "terminal.integrated.profiles.linux" = {
          "zsh" = {
            "path" = "/run/current-system/sw/bin/zsh";
          };
          "bash" = {
            "path" = "/run/current-system/sw/bin/bash";
          };
          nu = {
            "path" = "/run/current-system/sw/bin/nu";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "zsh";

        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };

  programs.bash = {
    # without this, EDITOR is overwritten with nano
    initExtra = ''
      export EDITOR=vim
    '';
  };

  programs.zsh = {
    # without this, EDITOR is overwritten with nano
    initContent = ''
      export EDITOR=vim
    '';
  };


  imports = [ inputs.nix4nvchad.homeManagerModule ];
  programs.nvchad = {
    enable = true;
    backup = false;

    extraPackages = with pkgs; [ nixfmt-classic ];
    extraPlugins = ''
      return {
        {"stevearc/conform.nvim", lazy = true},
        {"benoror/gpg.nvim", lazy = false},
      }
    '';
    extraConfig = ''
      local M = require("chadrc")
      M.ui = M.ui or {}
      M.ui.theme = "catppuccin"
      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
            lsp_fallback = true,
          },
          formatters_by_ft = {
             nix = { "nixfmt" },
          },
      })
    '';
  };
}
