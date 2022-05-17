local config = {
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
}
require'nvim-treesitter.configs'.setup(config)
return config
