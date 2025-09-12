{ config, pkgs, inputs, ...  }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.rose-pine.enable = true;
    colorschemes.rose-pine.settings.variant = "dawn";
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      netrw_banner = 0;
      netrw_browser_split = 0;
      netrw_winsize = 25;
    };
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      swapfile = false;
      termguicolors = true;
      scrolloff = 8;
      laststatus = 2;
    };
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    keymaps = [
    {
      action = "<cmd>:Ex<cr>";
      key = "<leader>pv";
      mode = [ "n" ];
    }
    {
      action = "<c-^>";
      key = "<leader>b";
      mode = [ "n" ];
    }
    {
      action = "<cmd>:let @+ = 'cd ' .. expand('%:p:h')<cr>";
      key = "<leader>cd";
      mode = [ "n" ];
    }
    {
      action = "<cmd>:m '>+1<cr>gv=gv";
      key = "J";
      mode = [ "v" ];
    }
    {
      action = "<cmd>:m '>-2<cr>gv=gv";
      key = "K";
      mode = [ "v" ];
    }
    {
      action = "<gv";
      key = "<";
      mode = [ "v" ];
    }
    {
      action = ">gv";
      key = ">";
      mode = [ "v" ];
    }

    ];

    plugins = {
      fugitive.enable = true;
      lspconfig.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "/" = "current_buffer_fuzzy_find";
          "<leader>pf" = "find_files";
          "<leader>ps" = "live_grep";
        };
        settings.pickers = {
          find_files = {
            find_command = [ "rg" "--files" "--hidden" "--glob" "!**/.git/*" ];
          };
        };
      };
      treesitter.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
      blink-cmp = {
        enable = true;
        settings.keymap = {
          preset = "enter";
        };
      };
    };

    lsp = {
      keymaps = [
        {
          key = "gd";
          action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }

      ];
      servers = {
        bashls.enable = true;
        dockerls.enable = true;
        gopls.enable = true;
        helm_ls.enable = true;
        jsonls.enable = true;
        nixd.enable = true;
        terraformls.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
