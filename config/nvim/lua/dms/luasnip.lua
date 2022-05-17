local ls = require 'luasnip'
-- local types = require 'luasnip.util.types'

local s, i = ls.s, ls.insert_node
local t, c = ls.text_node, ls.choice_node
local f, d = ls.function_node, ls.dynamic_node
local fmt = require 'luasnip.extras.fmt'.fmt
-- local rep = require 'luasnip.extras'.rep

ls.config.set_config {
  history = true,
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
}

-- ls.cleanup()
ls.add_snippets("all", {})

ls.add_snippets("kotlin", {
  s("fn", fmt([[
    {}fun {}({}){} {{
        {}
    }}
  ]],
  {
    c(1, { t"", t"private " }),
    i(2, "<funcname>"),
    i(3),
    c(4, { t"", fmt(": {} <<{}>>", { i(1, "<type>"), i(2) }) }),
    i(0),
  }
  ))
})

ls.add_snippets("rust", {
  s("modtest", fmt([[
    #[cfg(test)]
    mod test {{
    {}

        {}
    }}
  ]],
  {
    c(1, { t '    use super::*;', t '' }),
    i(0),
  })),
  s("test", fmt([[
    #[test]
    fn {}() {} {{
      {}
    }}
  ]],
  {
    i(1, "testname"),
    (function (index)
      return d(index, function()
        local node = t "default"

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do
          if line:match("anyhow::Result") then
            node = c(1, { t"-> default", fmt("-> Result<({})>", { i(1, "type") })})
            break
          end
        end
        return ls.sn(nil, node)
      end, {})
    end)(2),
    i(0),
  }))
})

ls.add_snippets("lua", {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n  $0\nend"),
  ls.parser.parse_snippet("mf", "function $1.$2($3)\n  $0\nend"),
  s("req", fmt("local {} = require '{}'", { f(function(args)
    local parts = vim.split(args[1][1], '.', true)
    return parts[#parts] or ""
  end, { 1 }), i(1) })),
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = "next_snippet"})

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = "previous_snippet" })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { desc = "cycle_snippets" })

-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/dms/luasnip.lua<CR>")
