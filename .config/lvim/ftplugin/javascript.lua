-------------------------------------------------------------------------------
-- Vim::Options
-------------------------------------------------------------------------------

do
  local spaces = 2
  vim.opt_local.tabstop = spaces
  vim.opt_local.shiftwidth = spaces
  vim.opt_local.softtabstop = spaces
end



-------------------------------------------------------------------------------
-- Running / Executing
-------------------------------------------------------------------------------

local run_node_program = function()
  local file = vim.fn.expand("%") -- Get the currently open file

  local Terminal = require("toggleterm.terminal").Terminal
  -- Create a new terminal instance
  local term = Terminal:new({
    cmd = string.format("node %s", file),
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
  run_node_program, "Run file in node"
}



-------------------------------------------------------------------------------
-- Debugging
-------------------------------------------------------------------------------

-- There are two parts for debugging a node.js program:
-- 1. Running the program with --inspect so that the native Node debugger acts
--    as a server that controls the debugging
-- 2. Running a DAP client to communicate with the Node debug server in order
--    to send instructions (e.g. run to cursor, wherever it may be)

local node_port = 9229
local job_id = nil


--- 1. Run Node.js in inspection mode (debug)

-- local start_node_debug = function()
--   local file = vim.fn.expand("%") -- Get the currently open file
--   local port = node_port          -- The port to connect to (Node.js debugger)

--   -- Start the Node.js process with the --inspect flag
--   local command = string.format("node --inspect=%d %s", port, file)

--   -- Run the command asynchronously and store id for later killing
--   job_id = vim.fn.jobstart(command, {
--     on_exit = function(_, exit_code, _)
--       print("Process exited with exit code: ", exit_code)
--     end,
--   })

--   if job_id > 0 then
--     vim.notify("An error occurred!!", vim.log.levels.ERROR)
--   else
--     vim.notify(string.format("Started debugging file %s on port %d", file, port))
--   end
-- end

-- local stop_node_debug = function ()
--   if job_id then
--     vim.fn.jobstop(job_id)
--     job_id = nil
--     vim.notify("Program stopped")
--   else
--     vim.notify("No node program started by lvim running")
--   end
-- end

-- -- Add keybinds for starting and stopping the program
-- lvim.builtin.which_key.mappings.d.s = {
--   start_node_debug, "Run in inspector mode"
-- }

-- lvim.builtin.which_key.mappings.d.S = {
--   stop_node_debug, "Stop running the program"
-- }


--- 2. Debug Adapter Protocol (DAP)

-- Override or extend configuration of lvim.builtin.dap
local dap = require("dap")

-- JavaScript / Nodejs
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = tostring(node_port),
  executable = {
    command = "node",
    args = {
      "/home/juanma/.local/share/lvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      tostring(node_port)
    },
  },
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}
