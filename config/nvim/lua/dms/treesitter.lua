local config = {
  ensure_installed = { "markdown" },
  highlight = {
    enable = true,
    disable = { "latex" },
    additional_vim_regex_highlighting = { "latex", "markdown" },
  },
  indent = {
    enable = false,
  },
}
require'nvim-treesitter.configs'.setup(config)
return config
