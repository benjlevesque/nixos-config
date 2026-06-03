{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    nil
    nixfmt
  ];

  programs.vscode = {
    enable = true;
    package = unstable.vscode;

    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          jnoortheen.nix-ide
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = [ "nixfmt" ];
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
        };
        "terminal.integrated.defaultProfile.linux" = "zsh";

        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "json.schemaDownload.trustedDomains" = {
          "https://schemastore.azurewebsites.net/" = true;
          "https://raw.githubusercontent.com/microsoft/vscode/" = true;
          "https://raw.githubusercontent.com/devcontainers/spec/" = true;
          "https://www.schemastore.org/" = true;
          "https://json.schemastore.org/" = true;
          "https://json-schema.org/" = true;
          "https://developer.microsoft.com/json-schemas/" = true;
          "https://biomejs.dev" = true;
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

    extraPackages = with pkgs; [ nixfmt ];
    extraPlugins = ''
      return {
        {"stevearc/conform.nvim", lazy = true},
        {"benoror/gpg.nvim", lazy = false},
      }
    '';
    extraConfig = ''
      require("chadrc")
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
    chadrcConfig = ''
      local M = {}
      M.ui = M.ui or {}
      M.ui.theme = "catppuccin"
      M.nvdash = {
          load_on_startup = true,
      }
      return M
    '';
  };

  programs.zed-editor.enable = true;
}
