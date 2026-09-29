return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
    config = function()
      local neocodeium = require("neocodeium")

      neocodeium.setup({
        enabled = true,
        silent = true,
      })

      -- Accept the current suggestion
      vim.keymap.set("i", "<C-j>", function()
        return neocodeium.accept()
      end, { expr = true, silent = true })

      -- Next suggestion
      vim.keymap.set("i", "<C-n>", function()
        return neocodeium.cycle_or_complete()
      end, { expr = true, silent = true })

      -- Previous suggestion
      vim.keymap.set("i", "<C-p>", function()
        return neocodeium.cycle_or_complete(-1)
      end, { expr = true, silent = true })

      -- Dismiss suggestion
      vim.keymap.set("i", "<C-x>", function()
        return neocodeium.clear()
      end, { expr = true, silent = true })
    end,
  },
}
