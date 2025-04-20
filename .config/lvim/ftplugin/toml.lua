-------------------------------------------------------------------------------
-- Vim::Options
-------------------------------------------------------------------------------
require("lvim.lsp.manager").setup("taplo")

do
  local spaces = 2
  vim.opt_local.tabstop = spaces
  vim.opt_local.shiftwidth = spaces
  vim.opt_local.softtabstop = spaces
end
