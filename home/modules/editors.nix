{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    nixd
    nixfmt
    gopls
    gofumpt
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

  imports = [ inputs.nix4nvchad.homeManagerModules.default ];
  programs.nvchad = {
    enable = true;
    backup = false;

    extraPackages = with pkgs; [
      nixfmt
      gopls
      gofumpt
    ];
    extraPlugins = ''
      return {
        {"stevearc/conform.nvim", lazy = true},
        {"benoror/gpg.nvim", lazy = false},
      }
    '';
    extraConfig = ''
      require("chadrc")
      vim.opt.relativenumber = true
      require("lspconfig").gopls.setup({})

      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
            lsp_fallback = true,
          },
          formatters_by_ft = {
             nix = { "nixfmt" },
             go = { "gofumpt" },
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
