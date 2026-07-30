return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- formatting
      "stevearc/conform.nvim",
    },
    config = function()
      local servers = {
        "bashls",
        "dockerls",
        "gopls",
        "helm_ls",
        "jsonls",
        "terraformls",
        "yamlls",
        "lua_ls",
      }

      vim.diagnostic.config({
        virtual_text = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        performance = {
          debounce = 60,
          throttle = 30,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-@>"] = cmp.mapping.complete(),
          ["<C-a>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<BS>"] = cmp.mapping(function(fallback)
            fallback()
            vim.schedule(function()
              local col = vim.fn.col(".") - 1
              local before = vim.fn.getline("."):sub(1, col)
              if before:match("[%w_]$") == nil then
                cmp.close()
              end
            end)
          end, { "i" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer", keyword_length = 3 },
        },
        experimental = {
          ghost_text = false,
        },
      })

      vim.o.completeopt = "menu,menuone,noselect"
      vim.o.shortmess = vim.o.shortmess .. "c"

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local function on_attach(_, bufnr)
        local opts = { silent = true, buffer = bufnr }
        local tb = require("telescope.builtin")

        vim.keymap.set("n", "<C-d>", tb.lsp_definitions, opts)
        vim.keymap.set("n", "<C-r>", tb.lsp_references, opts)
        vim.keymap.set("n", "<C-t>", tb.lsp_type_definitions, opts)
        vim.keymap.set("n", "<C-i>", tb.lsp_implementations, opts)

        vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-S>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "<C-f>", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      require("conform").setup({
        formatters_by_ft = {
          go = { "gofmt" },
          lua = { "stylua" },
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true })
      end, { silent = true, desc = "Format buffer" })

      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
        vim.lsp.enable(server)
      end
    end,
  },
}
