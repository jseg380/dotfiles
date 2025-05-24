-------------------------------------------------------------------------------
--                           _    ___                                        --
--                          | |  / (_)___ ___                                --
--                          | | / / / __ `__ \                               --
--                          | |/ / / / / / / /                               --
--                          |___/_/_/ /_/ /_/                                --
-------------------------------------------------------------------------------

-- Options
vim.opt.tabstop = 4               -- Size of tabs in spaces
vim.opt.shiftwidth = 0            -- Use same as tabstop for >>,<<
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.termguicolors = true      -- Use GUI colors
vim.opt.colorcolumn = "80"        -- Marker at 80th char
vim.opt.clipboard = "unnamedplus" -- For system clipboard
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false


-- Soft wrapping
vim.opt.wrap = false              -- Disabled by default
vim.opt.showbreak = "↳\\"         -- Show char at new line when it is wrapped
vim.opt.linebreak = true
vim.opt.breakindent = true


-- Custom commands
-- Toggle colorcolumn width between these values: [80, 120]
vim.api.nvim_create_user_command(
  "ToggleCC",
  function()
    local defaultCC = "80"
    local wideCC = "120"
    local currentCC = vim.opt.colorcolumn._value

    -- Toggle between defaultCC and wideCC
    local newCC = (currentCC == defaultCC) and wideCC or defaultCC
    vim.opt.colorcolumn = newCC
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  "SetIndent",
  function(args)
    local size = tonumber(args.fargs[1])
    vim.opt.tabstop = size
    vim.opt.shiftwidth = size
  end,
  { nargs = 1 }
)


-- Custom autocommands
-- TODO: not working
-- vim.api.nvim_create_autocmd(
--   "BufReadPost",
--   {
--     pattern = "*",
--     callback = function()
--       vim.cmd([[
--         syntax match TraceKeyword /\v#\s*TRACE/
--         highlight TraceKeyword ctermfg=16 ctermbg=214
--       ]])
--     end,
--   }
-- )
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "ssh-config",
  callback = function(args)
    vim.bo[args.buf].filetype = "sshconfig"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "build.sh", "*.subpackage.sh", "PKGBUILD", "*.install",
      "makepkg.conf", "*.ebuild", "*.eclass", "color.map", "make.conf" },
  callback = function(args)
    vim.lsp.start({
      name = "termux",
      cmd = { "termux-language-server" }
    })
    vim.bo[args.buf].filetype = "bash-build"
  end,
})





-------------------------------------------------------------------------------
--               __                          _    ___                        --
--              / /   __  ______  ____ _____| |  / (_)___ ___                --
--             / /   / / / / __ \/ __ `/ ___/ | / / / __ `__ \               --
--            / /___/ /_/ / / / / /_/ / /   | |/ / / / / / / /               --
--           /_____/\__,_/_/ /_/\__,_/_/    |___/_/_/ /_/ /_/                --
-------------------------------------------------------------------------------

-- List all available options for lvim
--[[
cd $HOME/.config/lvim && \
lvim --headless +'lua require("lvim.utils").generate_settings()' +qa && \
sort -o lv-settings.lua{,} && \
cat lv-settings.lua
--]]

-------------------------------------------------------------------------------
-- General
-------------------------------------------------------------------------------

-- Colorscheme
-- lvim.colorscheme = "lunar"


-- Disable icons, minimalist setup
-- lvim.use_icons = false


-- lvim.log.level = "info"


-- Format on save
-- lvim.format_on_save = {
--   enabled = true,
--   pattern = "*.lua",
--   timeout = 1000,
-- }

-- Reload config on save
lvim.reload_config_on_save = false


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

-- Complete commandline (cmp-cmdline)
lvim.builtin.cmp.cmdline.enable = true


-- Treesitter (nvim-treesitter)
lvim.builtin.treesitter.ignore_install = {
  "haskell",
  "ruby"
}


-- Additional plugin list
lvim.plugins = {
  -- Markdown
  {
    "brianhuster/live-preview.nvim",
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",  -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {},
  },

  -- Latex
  {
    "lervag/vimtex",
    lazy = false, -- As per the documentation
    init = function()
      -- VimTeX configuration goes here
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_fold_enabled = true
    end
  },

  -- Symbols Outline (list of functions and variables)
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
    config = function()
      require("symbols-outline").setup()
    end,
  },

  -- Docstring generator
  {
    "danymat/neogen",
    config = true,
  },

  -- Session persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",  -- load early so it can restore
    config = function()
      require("persistence").setup({
        options = { "buffers", "curdir", "tabpages", "winsize", "help", 
          "globals", "skiprtp" },
      })
    end,
  },

  -- Library of independent Lua modules for improving overall nvim experience
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function ()
      require("mini.align").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },

        -- Default options controlling alignment process
        options = {
          split_pattern = '',
          justify_side = 'left',
          merge_delimiter = '',
        },

        -- Default steps performing alignment (if `nil`, default is used)
        steps = {
          pre_split = {},
          split = nil,
          pre_justify = {},
          justify = nil,
          pre_merge = {},
          merge = nil,
        },

        -- Whether to disable showing non-error feedback
        -- This also affects (purely informational) helper messages shown after
        -- idle time if user input is required.
        silent = false,
      })
    end
  },

  -- Debugger Adapter Protocol (DAP)
  {
    enabled = false,
    "mfussenegger/nvim-dap",
  },
  {
    enabled = false,
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    enabled = false,
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    -- enabled = false,
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = { "Copilot" },
    config = function()
      -- Set copilot mappings
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Accept suggestion
      vim.keymap.set('i', '<S-CR>', 'copilot#Accept("<CR>")',
        { noremap = true, silent = true, expr=true, replace_keycodes = false })
    end,
  }
}


-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

-- Reference: ~/.local/share/lunarvim/lvim/lua/lvim/keymappings.lua

-- lvim.keys


-- WhichKey: default values unassignments
lvim.builtin.which_key.mappings.b.W = nil
lvim.builtin.which_key.mappings.d.g = nil
lvim.builtin.which_key.mappings.T = nil
lvim.builtin.which_key.mappings[";"] = nil


-- WhichKey: assignments
lvim.builtin.which_key.mappings["b"]["<Left>"] = {
  "<cmd>BufferLineMovePrev<cr>", "Move buffer to the left"
}

lvim.builtin.which_key.mappings["b"]["<Right>"] = {
  "<cmd>BufferLineMoveNext<cr>", "Move buffer to the right"
}

lvim.builtin.which_key.mappings.b.d = {
  "<cmd>Neogen<cr>", "Generate docstring"
}

lvim.builtin.which_key.mappings.T = {
  name = "Tabs",
  t = { "<cmd>tabnew<CR>", "New Tab" },
  n = { "<cmd>tabnext<CR>", "Next Tab" },
  b = { "<cmd>tabprevious<CR>", "Previous Tab" },
  c = { "<cmd>tabclose<CR>", "Close Tab" },
}

lvim.builtin.which_key.mappings.S = {
  name = "Session",
  s = { function() require("persistence").load() end, "Restore session (cwd)" },
  l = { function() require("persistence").load({ last = true }) end, "Restore last session" },
  d = { function() require("persistence").stop() end, "Disable session saving" },
}

lvim.builtin.which_key.mappings["C"] = {
  name = "Copilot",
  p = { "<cmd>Copilot panel<CR>", "Open Panel" },
  s = { "<cmd>Copilot status<CR>", "Status" },
  e = { "<cmd>Copilot enable<CR>", "Enable" },
  d = { "<cmd>Copilot disable<CR>", "Disable" },
}


-------------------------------------------------------------------------------
-- Language Server Protocol (LSP)
-------------------------------------------------------------------------------

-- Disable automatic installation of LSP
-- lvim.lsp.installer.setup.automatic_installation = false


-- Increase LSP logging level
vim.lsp.set_log_level("debug")


-- Fish LSP
-- Set up fish-lsp server as instructed in the official documentation
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = "fish",
    callback = function()
      vim.lsp.start({
        name = "fish-lsp",
        cmd = { "fish-lsp", "start" },
        cmd_env = { fish_lsp_show_client_popups = false },
      })
    end,
  }
)

-- Solargraph (Ruby)
-- Disable automatic configuration
-- table.insert(lvim.lsp.automatic_configuration.skipped_servers, "solargraph")
-- table.remove(lvim.lsp.automatic_configuration.skipped_servers.)
-- vim.list_extend(
--  lvim.lsp.automatic_configuration.skipped_servers,
--  {"solargraph"}
-- )

-- print(lvim.lsp.automatic_configuration.skipped_servers)
-- require("lvim.lsp.manager").setup()


-- -- JDTLS (Java)
-- -- Disable automatic configuration for jdtls
-- vim.list_extend(
--  lvim.lsp.automatic_configuration.skipped_servers,
--  {"jdtls"}
-- )
-- require("lvim.lsp.manager").setup(
--  "jdtls",
--  {
--    root_dir = function()
--    end,
--  }
-- )


--[[
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
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup() {
--   { command = "pycodestyle", filetypes = { "python" }},
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
-- Debug Adapter Protocol (DAP)
-------------------------------------------------------------------------------

-- Override or extend configuration of lvim.builtin.dap
-- local dap = require("dap")
