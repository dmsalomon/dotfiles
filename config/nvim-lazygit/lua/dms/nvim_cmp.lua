local cmp = require'cmp'

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local config = {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-b>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.abort(),
    ['<c-k>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-n>'] = cmp.mapping.select_next_item(),
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_document_symbol' },
    -- { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'cmp_git' },
    { name = 'emoji' , option = { insert = true } },
  }, {
    { name = 'calc' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function ()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  }),
  formatting = {
    format = require'lspkind'.cmp_format {
      with_text = true,
      mode = 'symbol_text',
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[lsp]',
        nvim_lua = '[api]',
        path = '[path]',
        luasnip = '[snip]',
        dictionary = '[dict]',
        emoji = '[emoji]',
        calc = '[calc]',
        cmp_git = '[git]',
      }
    }
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  }
}

cmp.setup(config)
return config
