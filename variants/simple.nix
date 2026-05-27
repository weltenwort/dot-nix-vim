{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../modules/lint.nix
    ../modules/lang-nix.nix
    ../modules/neogit.nix
    ../modules/diffview.nix
  ];

  config =
    let
      helpers = lib.nixvim;
    in
    {
      globals = {
        mapleader = " ";
        maplocalleader = ",";
      };

      opts = {
        number = true;
        relativenumber = true;
        showmode = false;
        mouse = "a";
        breakindent = true;
        undofile = true;
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };
        splitright = true;
        splitbelow = true;
        signcolumn = "yes";
        cursorline = true;
        scrolloff = 10;
      };

      extraPackages = [
        pkgs.ripgrep
      ];

      plugins.lualine = {
        enable = true;
      };

      plugins.conform-nvim = {
        enable = true;
        settings = {
          format_on_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              return { timeout_ms = 200, lsp_fallback = true }
             end
          '';
          format_after_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              return { lsp_fallback = true }
            end
          '';
          log_level = "warn";
        };
      };

      plugins.lsp.enable = true;

      plugins.sleuth.enable = true;

      plugins.telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "+" = "buffers";
        };
      };

      plugins.cmp = {
        enable = true;
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          ai = { };
          basics = { };
          bracketed = { };
          bufremove = { };
          clue = {
            triggers = helpers.listToUnkeyedAttrs [
              # Leader triggers
              {
                mode = "n";
                keys = "<Leader>";
              }
              {
                mode = "x";
                keys = "<Leader>";
              }

              # Built-in completion
              {
                mode = "i";
                keys = "<C-x>";
              }

              # `g` key
              {
                mode = "n";
                keys = "g";
              }
              {
                mode = "x";
                keys = "g";
              }

              # Marks
              {
                mode = "n";
                keys = "'";
              }
              {
                mode = "n";
                keys = "`";
              }
              {
                mode = "x";
                keys = "'";
              }
              {
                mode = "x";
                keys = "`";
              }

              # Registers
              {
                mode = "n";
                keys = "\"";
              }
              {
                mode = "x";
                keys = "\"";
              }
              {
                mode = "i";
                keys = "<C-r>";
              }
              {
                mode = "c";
                keys = "<C-r>";
              }

              # Window commands
              {
                mode = "n";
                keys = "<C-w>";
              }

              # `z` key
              {
                mode = "n";
                keys = "z";
              }
              {
                mode = "x";
                keys = "z";
              }

              # bracketed
              {
                mode = "n";
                keys = "[";
              }
              {
                mode = "n";
                keys = "]";
              }
            ];

            clues = helpers.listToUnkeyedAttrs [
              # Enhance this by adding descriptions for <Leader> mapping groups
              (helpers.mkRaw "require('mini.clue').gen_clues.builtin_completion()")
              (helpers.mkRaw "require('mini.clue').gen_clues.g()")
              (helpers.mkRaw "require('mini.clue').gen_clues.marks()")
              (helpers.mkRaw "require('mini.clue').gen_clues.registers()")
              (helpers.mkRaw "require('mini.clue').gen_clues.windows()")
              (helpers.mkRaw "require('mini.clue').gen_clues.z()")
            ];
          };
          extra = { };
          files = { };
          icons = { };
          indentscope = {
            draw.animation.__raw = "require('mini.indentscope').gen_animation.none()";
          };
          notify = { };
          pairs = { };
          pick = { };
          sessions = { };
          starter = { };
          statusline = { };
          tabline = { };
        };
      };

      keymaps = [
        {
          action = ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>";
          key = "-";
          mode = [ "n" ];
        }
        {
          action = ":Pick help<cr>";
          key = "<leader>ph";
          mode = [ "n" ];
        }
        {
          action = ":Pick files<cr>";
          key = "<leader>ph";
          mode = [ "n" ];
        }
      ];
    };
}
