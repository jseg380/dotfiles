-------------------------------------------------------------------------------
-- Vim::Options
-------------------------------------------------------------------------------
require("lvim.lsp.manager").setup("vale_ls")



-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

-- WhichKey: assignments
lvim.builtin.which_key.mappings["t"] = {
  name = "LaTeX",
  l = { "<cmd>VimtexCompile<CR>", "Compile LaTeX" },
  f = { "<cmd>VimtexView<CR>", "View PDF" },
}
lvim.builtin.which_key.mappings.r = {
  "<cmd>LivePreview start<cr>", "Preview MD file"
}
