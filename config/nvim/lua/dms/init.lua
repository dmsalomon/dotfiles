if require 'dms.bootstrap'() then
  return
end

require 'dms.plugins'
vim.g.dracula_colorterm = 0
require 'dms.lsp'
require 'dms.nvim_cmp'
require 'dms.util'
require 'dms.luasnip'
