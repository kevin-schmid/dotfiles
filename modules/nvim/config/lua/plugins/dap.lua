return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local ok_dap, dap = pcall(require, "dap")
      if not ok_dap then
        vim.notify("nvim-dap not installed", vim.log.levels.WARN)
        return
      end

      pcall(function()
        require("dap-go").setup()
      end)

      local ok_ui, dapui = pcall(require, "dapui")
      if ok_ui then
        dapui.setup()
        -- auto open/close on events
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      end

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, opts)
      vim.keymap.set("n", "<leader>dc", function() dap.continue() end, opts)
      vim.keymap.set("n", "<leader>di", function() dap.step_into() end, opts)
      vim.keymap.set("n", "<leader>do", function() dap.step_over() end, opts)
      vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, opts)
      vim.keymap.set("n", "<leader>du", function() if ok_ui then dapui.toggle() end end, opts)
    end,
  }
}
