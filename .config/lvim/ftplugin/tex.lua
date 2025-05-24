-------------------------------------------------------------------------------
-- Vim::Options
-------------------------------------------------------------------------------

-- From: https://blog.epheme.re/software/nvim-latex.html
-- From: https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#L4671-L4713
-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
-- vim.opt_local.foldtext = "vimtex#fold#text()"
-- vim.opt_local.foldlevel = 2  -- See content of the sections upon opening

-- Remove color column
vim.opt_local.colorcolumn = ""



-------------------------------------------------------------------------------
-- Lunarvim::Options
-------------------------------------------------------------------------------

-- Disable highlighting with nvim-treesitter
lvim.builtin.treesitter.highlight.enable = false


-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

-- WhichKey: assignments
lvim.builtin.which_key.mappings["t"] = {
  name = "LaTeX",
  g = { "<cmd>VimtexCompile<CR>", "Generate PDF" },
  s = { "<cmd>VimtexStopAll<CR>", "Stop all compilations" },
  p = { "<cmd>VimtexView<CR>", "Preview PDF" },
  c = { "<cmd>VimtexClean<CR>", "Clean aux files" },
  C = { "<cmd>VimtexClean!<CR>", "Clean all aux files" },
}

-- Default mappings unassignments
lvim.lsp.buffer_mappings.normal_mode.K[1] = function ()
  vim.cmd("VimtexDocPackage")
end
