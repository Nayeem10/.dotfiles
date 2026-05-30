-- =========================
-- Keymaps Configuration
-- =========================

-- Helper function for keymaps (defaults: noremap = true, silent = true)
local map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- =========================
-- Escape / Backspace
-- =========================
map("i", "jj", "<Esc>")                     -- Escape insert mode
map("t", "jj", "<C-\\><C-n>")               -- Escape terminal mode
-- map("i", "kk", "<BS>")                      -- kk as backspace in insert mode

-- =========================
-- Window Management
map("n", "<C-l>", "<C-w>l")
map("n", "<C-Right>", "<C-w>l")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-Up>", "<C-w>k")

-- =========================
-- Plugin Mappings
map("n", "<F5>", function() require("dap").continue() end)  -- Debugging (nvim-dap)
map("n", "<C-n>", ":NvimTreeToggle<CR>")                     -- NvimTree toggle
map("n", "<C-f>", ":Telescope find_files<CR>")              -- Telescope find files

-- =========================
-- Editing / Clipboard
map("i", "<C-a>", "<C-o>gg<C-o>VG")                         -- Select all in insert mode
map("n", "<C-c>", '"+y')                                    -- Copy in normal mode
map("v", "<C-c>", '"+y')                                    -- Copy selection
map("i", "<C-v>", '<C-r>+')                                 -- Paste from system clipboard
map({"n", "v"}, "d", "\"_d")                                       -- Delete without copying

-- =========================
-- Build / Compile / Run (For CP only)
-- vim.keymap.set({'n', 'v', 'i'}, '<C-b>', function()
--   -- Save ALL open buffers
--   vim.cmd('wall')
--
--   local file = vim.fn.expand('%')
--   local bin = vim.fn.expand('%:r')
--
--   local cmd = string.format('clear && g++ -std=c++17 -Wall "%s" -o "%s" && ./"%s" < input.txt > output.txt 2>&1 && rm "%s"', file, bin, bin, bin)
--
--   -- Look for an existing terminal window
--   local term_win = nil
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     if vim.bo[buf].buftype == 'terminal' then
--       term_win = win
--       break
--     end
--   end
--
--   -- FIX 1: Use 'botright 10new' instead of '10sp | term'
--   -- This creates a clean 10-row split at the bottom without spawning a conflicting shell
--   if not term_win then
--     vim.cmd('botright 8new')
--     term_win = vim.api.nvim_get_current_win()
--   end
--
--   -- Run the command inside the terminal using jobstart
--   vim.api.nvim_win_call(term_win, function()
--     local old_buf = vim.api.nvim_get_current_buf()
--
--     -- FIX 2: If we are reusing a window that already has an old terminal session,
--     -- swap it out for a completely pristine, empty buffer ('enew') so jobstart works perfectly.
--     if vim.bo[old_buf].buftype == 'terminal' then
--       vim.cmd('enew')
--       vim.api.nvim_buf_delete(old_buf, { force = true }) -- Clean up the old buffer from memory
--     elseif vim.api.nvim_buf_get_name(old_buf) ~= "" or vim.bo[old_buf].modified then
--       vim.cmd('enew')
--     end
--
--     vim.fn.jobstart({'bash', '-c', cmd}, {
--       term = true, 
--
--       -- This callback fires the exact millisecond the command finishes execution
--       on_exit = function(_, exit_code, _)
--         -- Force reload ALL buffers instantly
--         vim.schedule(function()
--           vim.cmd('checktime')
--
--           -- Optional: Let you know if the compilation or run step broke
--           if exit_code ~= 0 then
--             vim.notify("Execution failed with exit code " .. exit_code, vim.log.levels.WARN)
--           end
--         end)
--       end
--     })
--   end)
--
-- end, { desc = 'Save, compile C++, output to file, and reload all buffers on completion' })


-- This one opens interactive terminal
vim.keymap.set({'n', 'v', 'i'}, '<C-b>', function()
  -- Save ALL open buffers
  vim.cmd('wall')

  local file = vim.fn.expand('%')
  local bin = vim.fn.expand('%:r')
  
  local cpp_cmd = string.format('g++ -std=c++17 -Wall "%s" -o "%s" && ./"%s" < input.txt > output.txt 2>&1 && rm "%s"', file, bin, bin, bin)
  
  -- We use a semicolon (;) so this runs even if compilation fails (allowing you to see errors in output.txt)
  local full_cmd = string.format('clear && ( %s ); nvim --server "$NVIM" --remote-send "<Cmd>checktime<CR>"', cpp_cmd)

  -- Look for an existing open terminal window
  local chan_id = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      chan_id = vim.b[buf].terminal_job_id
      if chan_id then break end
    end
  end

  -- If no terminal window is visible, open a true interactive terminal split at the bottom
  if not chan_id then
    vim.cmd('botright 10sp | term')
    local buf = vim.api.nvim_get_current_buf()
    chan_id = vim.b[buf].terminal_job_id
  end

  -- Send the command to the living, interactive terminal channel
  if chan_id then
    vim.api.nvim_chan_send(chan_id, full_cmd .. '\n')
  else
    vim.notify("Could not find or initialize terminal channel.", vim.log.levels.ERROR)
  end

end, { desc = 'Save, compile C++, output to file, and reload all buffers on completion' })
