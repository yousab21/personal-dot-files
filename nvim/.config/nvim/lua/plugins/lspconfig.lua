-- lua/plugins/lspconfig.lua
--
-- LazyVim already configures most "core" language servers automatically
-- (lua_ls, pyright, tsserver, etc. get set up via mason-lspconfig with no
-- extra work). This file is only for servers LazyVim doesn't wire up by
-- default, or where you need to override the default cmd/settings.
--
-- Pattern: each server gets one entry in the `servers` table below.
-- To add a new language later (e.g. omnisharp for .NET), copy one of the
-- existing blocks, rename the key to the server's lspconfig name, and
-- fill in `cmd` / `filetypes` / `settings` as needed.
--
-- Server name lookup: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- Mason package lookup: :Mason inside nvim, or https://mason-registry.dev/registry/list

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {

      -- ============================================================
      -- Arduino (.ino files)
      -- Requires: arduino-cli (on $PATH), clangd (via Mason), and
      -- arduino-language-server (via Mason or manual go install, since
      -- it isn't packaged for Fedora).
      -- ============================================================
      arduino_language_server = {
        cmd = {
          "arduino-language-server",

          -- clangd handles the actual C/C++ intelligence under the hood;
          -- point it at the Mason-installed binary so versions stay in sync
          -- with whatever else Mason manages.
          "-clangd",
          "/usr/bin/clangd",

          -- arduino-cli must already be resolvable on $PATH (see ~/bin setup)
          "-cli",
          "arduino-cli",

          -- Config file created once via: arduino-cli config init
          "-cli-config",
          vim.fn.expand("~/.arduino15/arduino-cli.yaml"),

          -- Fully Qualified Board Name — hardcoded per-project for now.
          -- Change this to match whatever board you're actively targeting.
          "-fqbn",
          "arduino:avr:uno",
        },
        filetypes = { "arduino" },

        -- IMPORTANT: do not pass `capabilities` here. Older versions of
        -- arduino-language-server (pre-0.7.7) break on nvim 0.10+ if extra
        -- LSP capabilities are negotiated. Leave this server's capabilities
        -- untouched even if you set a global capabilities table elsewhere.
      },

      -- ============================================================
      -- .NET / C# (template — uncomment and fill in when needed)
      -- Requires: omnisharp (via Mason: :MasonInstall omnisharp) and the
      -- .NET SDK installed separately (Mason does not provide the SDK).
      -- ============================================================
      -- omnisharp = {
      --   cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/omnisharp") },
      --   filetypes = { "cs", "vb" },
      --   settings = {
      --     FormattingOptions = {
      --       EnableEditorConfigSupport = true,
      --     },
      --     RoslynExtensionsOptions = {
      --       EnableAnalyzersSupport = true,
      --     },
      --   },
      -- },

      -- ============================================================
      -- Add future servers here following the same shape:
      --
      -- <lspconfig_server_name> = {
      --   cmd = { ... },          -- omit entirely to use lspconfig's default
      --   filetypes = { ... },    -- omit to use lspconfig's default
      --   settings = { ... },     -- server-specific settings table
      -- },
      -- ============================================================
    },
  },
}
