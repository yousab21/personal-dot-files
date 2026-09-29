return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_enable_italic = true
      vim.g.everforest_transparent_background_level = 2
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_current_word = "grey background"

      vim.o.background = "dark"
      vim.cmd.colorscheme("everforest")

      local function make_transparent()
        local groups = {
          -- Core
          "Normal",
          "NormalNC",
          "NormalFloat",
          "FloatBorder",
          "SignColumn",
          "EndOfBuffer",

          -- Tabs/status
          "TabLine",
          "TabLineFill",
          "TabLineSel",
          "StatusLine",
          "StatusLineNC",
          "WinSeparator",

          -- Neo-tree
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "NeoTreeEndOfBuffer",
          "NeoTreeFloatNormal",
          "NeoTreeFloatBorder",

          -- Mason
          "MasonNormal",
          "MasonNormalFloat",
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
      end

      -- Apply immediately
      make_transparent()

      -- Re-apply whenever the colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = make_transparent,
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
