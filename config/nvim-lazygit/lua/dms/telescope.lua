local telescope = require 'telescope'
local tb = require 'telescope.builtin'
local config = {
  defaults = {
    prompt_prefix = "> ",
    mappings = {
      i = {
        ["<c-h>"] = "which_key",
        ["<c-j>"] = "move_selection_next",
        ["<c-k>"] = "move_selection_previous",
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
    }
  },
}

local kn = function(lhs, fn)
  vim.keymap.set('n', lhs, tb[fn], { desc = "Telescope " .. fn })
end

kn('<silent><c-p>', 'find_files')
kn('<leader>ff', 'find_files')
kn('<leader>fG', 'git_files')
kn('<leader>fg', 'live_grep')
kn('<leader>fb', 'buffers')
kn('<leader>fh', 'help_tags')
kn('<leader>fk', 'keymaps')
kn('<leader>fo', 'oldfiles')
kn('<leader>fr', 'resume')

telescope.setup(config)
return config
