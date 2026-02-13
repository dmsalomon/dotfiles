
-- Check if we need to reload the file when it changed
Config.new_autocmd(
  { "FocusGained", "TermClose", "TermLeave" },
  nil,
  function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  'Check to reload file if changed'
)

-- close some filetypes with <q>
Config.new_autocmd(
  'FileType', {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
  'Close some filetypes with <q>'
)

Config.new_autocmd(
  "filetype",
  "help",
  function()
    vim.keymap.set("n", "<cr>", "<c-]>", { silent = true, buffer = true })
    vim.keymap.set("n", "<bs>", "<c-T>", { silent = true, buffer = true })
    vim.keymap.set("n", "q", ":q!<cr>", { silent = true, buffer = true })
  end,
  'help window navigation'
)

-- wrap and check for spell in text filetypes
local text_filetypes = {"text", "plaintex", "typst", "gitcommit", "markdown" }
Config.new_autocmd("FileType", text_filetypes,
  function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  'Wrap and check for spell in text filetypes'
)

-- Config.new_autocmd("BufEnter",
--   'term://*toggleterm*',
--   function()
--     vim.cmd.startinsert()
--   end,
--   'Auto insert for toggle term'
-- )

-- Config.new_autocmd(
--   { "BufRead", "BufNewFile" },
--   "/tmp/etc/nginx/sites-*/*",
--   "set ft=nginx",
--   "Detect nginx files"
-- )
