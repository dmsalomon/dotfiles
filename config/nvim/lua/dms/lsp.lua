local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'

local capabilities = require 'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "diagnostic open float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "next diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "prev diagnostic" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "diagnostic_setloclist" })

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = function(o)
    return vim.tbl_extend("force", o, { buffer = true })
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts { desc = "lsp declaration" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts { desc = "lsp definition" })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts { desc = "lsp hover" })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts { desc = "lsp implementation" })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts { desc = "lsp signature_help" })
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts {
    desc = "lsp add_workspace_folder"
  })
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts {
    desc = "lsp remove_workspace_folder"
  })
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts { desc = "lsp list_workspace_folders" })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts {
    desc = "lsp type_definition"
  })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts {
    desc = "lsp rename"
  })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts { desc = "lsp code_actions" })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts { desc = "lsp references" })
  vim.keymap.set('n', '<leader><leader>f', vim.lsp.buf.formatting_sync, opts { desc = "lsp formatting" })
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local servers = {
  pyright = true,
  ccls = true,
  tsserver = true,
  gopls = true,
  rust_analyzer = true,
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'P', 'RELOAD'},
          neededFileStatus = {
            ["lowercase-global"] = "None",
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  vimls = true,
  yamlls = true,
  terraformls = true,
  kotlin_language_server = {
    root_dir = util.root_pattern(unpack { "BUILD", "WORKSPACE" })
  },
  zls = true,
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  lspconfig[server].setup(
    vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = nil,
      },
    }, config)
  )
end

-- require'nlua.lsp.nvim'.setup(lspconfig, {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

for server, config in pairs(servers) do
  setup_server(server, config)
end
