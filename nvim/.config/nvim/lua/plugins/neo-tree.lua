return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", false }, -- disable LazyVim's default
    { "<C-A-t>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
    },
    window = {
      width = 30,
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
      },
    },
  },
}
