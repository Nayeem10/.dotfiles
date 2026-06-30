require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- Window Management
map("n", "<C-l>", "<C-w>l")
map("n", "<C-Right>", "<C-w>l")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-Up>", "<C-w>k")

-- Editing / Clipboard
map("i", "<C-a>", "<C-o>gg<C-o>VG")                         -- Select all in insert mode
map("n", "<C-c>", '"+y')                                    -- Copy in normal mode
map("v", "<C-c>", '"+y')                                    -- Copy selection
map("i", "<C-v>", '<C-r>+')                                 -- Paste from system clipboard


-- Build and run cpp files for cp only
map({'n', 'v', 'i'}, '<C-b>', function()
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
    vim.cmd('botright 6sp | term')
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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
