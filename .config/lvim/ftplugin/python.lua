-------------------------------------------------------------------------------
-- Running / Executing
-------------------------------------------------------------------------------

local run_python_program = function()
  local file = vim.fn.expand("%") -- Get the currently open file

  local Terminal = require("toggleterm.terminal").Terminal
  -- Create a new terminal instance
  local term = Terminal:new({
    cmd = string.format("python %s", file),
    direction = "float",
    close_on_exit = false,
  })

  -- Open the terminal and run the command
  term:toggle()
end



-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

-- WhichKey: assignments
lvim.builtin.which_key.mappings.r = {
  run_python_program, "Run python file"
}

lvim.builtin.which_key.mappings.l.f = {
  "<cmd>!ruff format --respect-gitignore --quiet %<CR>", "Format ruff"
}
