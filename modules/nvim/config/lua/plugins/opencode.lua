return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      { "nvim-mini/mini.diff" },
    },
    config = function()
      vim.o.autoread = true

      local _snapshots = {}   -- bufnr -> lines before opencode edit
      local _wrap_saved = {}  -- winid -> wrap value before overlay

      local function set_wrap(b)
        for _, w in ipairs(vim.fn.win_findbuf(b)) do
          _wrap_saved[w] = vim.wo[w].wrap
          vim.wo[w].wrap = true
        end
      end

      local function restore_wrap(b)
        for _, w in ipairs(vim.fn.win_findbuf(b)) do
          if _wrap_saved[w] ~= nil then
            vim.wo[w].wrap = _wrap_saved[w]
            _wrap_saved[w] = nil
          end
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:file.edited",
        callback = function(args)
          local file = args.data and args.data.event and args.data.event.properties and args.data.event.properties.file
          if not file then return end
          vim.schedule(function()
            vim.cmd("checktime")
            vim.defer_fn(function()
              local b = vim.fn.bufnr(file)
              if b == -1 or not _snapshots[b] then return end
              require("mini.diff").set_ref_text(b, _snapshots[b])
              set_wrap(b)
              require("mini.diff").toggle_overlay(b)
            end, 100)
          end)
        end,
      })

      vim.keymap.set({ "n", "x" }, "<leader>ai", function()
        local b = vim.api.nvim_get_current_buf()
        _snapshots[b] = vim.api.nvim_buf_get_lines(b, 0, -1, false)
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "AI inline edit" })

      vim.keymap.set("n", "<leader>aa", function()
        local b = vim.api.nvim_get_current_buf()
        if not _snapshots[b] then return end
        vim.cmd("write")
        local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
        require("mini.diff").set_ref_text(b, lines)
        require("mini.diff").toggle_overlay(b)
        restore_wrap(b)
        _snapshots[b] = nil
      end, { desc = "AI accept changes" })

      vim.keymap.set("n", "<leader>ar", function()
        local b = vim.api.nvim_get_current_buf()
        local original = _snapshots[b]
        if not original then return end
        vim.api.nvim_buf_set_lines(b, 0, -1, false, original)
        vim.cmd("write")
        require("mini.diff").set_ref_text(b, original)
        require("mini.diff").toggle_overlay(b)
        restore_wrap(b)
        _snapshots[b] = nil
      end, { desc = "AI reject changes" })

      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
    keys = {
      { "<leader>ai", desc = "AI inline edit",    mode = { "n", "x" } },
      { "<leader>aa", desc = "AI accept changes", mode = "n" },
      { "<leader>ar", desc = "AI reject changes", mode = "n" },
    },
  },
  {
    "nvim-mini/mini.diff",
    version = false,
    opts = {
      view = {
        style = "sign",
      },
      options = {
        wrap_goto = false,
      },
    },
  },
}
