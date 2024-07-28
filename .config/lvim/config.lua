-------------------------------------------------------------------------------
--                           _    ___                                        --
--                          | |  / (_)___ ___                                --
--                          | | / / / __ `__ \                               --
--                          | |/ / / / / / / /                               --
--                          |___/_/_/ /_/ /_/                                --
-------------------------------------------------------------------------------

-- Options
vim.opt.tabstop = 2                          -- Size of tabs in spaces
vim.opt.shiftwidth = 0                       -- Use same as tabstop for >>,<<
vim.opt.relativenumber = true                -- Relative line numbers
vim.opt.termguicolors = true                 -- Use GUI colors
vim.opt.colorcolumn = "80"                   -- Marker at 80th char
vim.opt.clipboard = "unnamedplus"            -- For system clipboard
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false





-------------------------------------------------------------------------------
--               __                          _    ___                        --
--              / /   __  ______  ____ _____| |  / (_)___ ___                --
--             / /   / / / / __ \/ __ `/ ___/ | / / / __ `__ \               --
--            / /___/ /_/ / / / / /_/ / /   | |/ / / / / / / /               --
--           /_____/\__,_/_/ /_/\__,_/_/    |___/_/_/ /_/ /_/                --
-------------------------------------------------------------------------------

-- List all available options for lvim 
-- cd $HOME/.config/lvim && \
-- lvim --headless +'lua require("lvim.utils").generate_settings()' +qa && \
-- sort -o lv-settings.lua{,} && \
-- cat lv-settings.lua

-------------------------------------------------------------------------------
-- General
-------------------------------------------------------------------------------

-- Colorscheme
-- lvim.colorscheme = "lunar"


-- Format on save
-- lvim.format_on_save = {
--   enabled = true,
--   pattern = "*.lua",
--   timeout = 1000,
-- }


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

lvim.plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin-theme",
    enabled = false,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "lervag/vimtex",
    lazy = true,    -- Do not load until necessary
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        autofold_depth = 1,
      })
    end,
  },
}


-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

-- See file ~/.local/share/lunarvim/lvim/lua/lvim/keymappings.lua
-- for the rest of modes


-- WhichKey
lvim.builtin.which_key.mappings["b"]["<Left>"] = {
  "<cmd>BufferLineMovePrev<cr>", "Move buffer to the left"
}

lvim.builtin.which_key.mappings["b"]["<Right>"] = {
  "<cmd>BufferLineMoveNext<cr>", "Move buffer to the right"
}

lvim.builtin.which_key.mappings["S"] = {
  "<cmd>SymbolsOutline<cr>", "Symbols outline"
}


-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

-- JDTLS (Java)
-- require("lvim.lsp.manager").setup("jdtls", {
--   root_dir = function()
--     return vim.fn.getcwd()
--   end,
-- })


--[[
--- disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pyright", opts)

---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
---`:LvimInfo` lists which server(s) are skipped for the current filetype
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "emmet_ls"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  --Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end
]]


-------------------------------------------------------------------------------
-- Linters
-------------------------------------------------------------------------------

-- -- Linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }


-------------------------------------------------------------------------------
-- Formatters
-------------------------------------------------------------------------------

-- -- Formatters
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }


-------------------------------------------------------------------------------
-- Builtin
-------------------------------------------------------------------------------

-- Treesitter
lvim.builtin.treesitter.ignore_install = { "haskell" }

-- Project
lvim.builtin.project.silent_chdir = false


-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------

lvim.autocommands = {
  {
    "BufWinEnter",
    {
      pattern = { "*.json", },
      callback = function()
        vim.cmd [[ setlocal tabstop=4 shiftwidth=4 ]]
      end
    },
  }
}
