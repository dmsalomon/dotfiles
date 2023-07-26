
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local has = function(x)
  return vim.fn.has(x) == 1
end

local is_wsl = (function()
  local output = vim.fn.systemlist "uname -r"
  return not not string.find(output[1] or "", "WSL")
end)()

local is_mac = has "maxunix"
local is_linux = not is_wsl and not is_mac

local packer = require'packer'
packer.init {
	max_jobs = 50,
}
packer.startup {
  function(use)
    use 'wbthomason/packer.nvim'

    -- Tpope
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-sensible'
    use 'tpope/vim-repeat'
    use 'tpope/vim-unimpaired'
    use { 'tpope/vim-commentary', disable = true }
    use 'tpope/vim-endwise'
    use 'tpope/vim-abolish'
    use 'tpope/vim-speeddating'
    use "tpope/vim-characterize"
    use { "tpope/vim-sleuth", disable = true }

    -- Window
    use {
      'airblade/vim-gitgutter',
      disable = true,
    }
    use {
      'airblade/vim-rooter.git',
      config = function()
        vim.g.rooter_patterns = { '.git', 'Makefile', 'package.json' }
      end,
      disable = true,
    }
    use {
      'preservim/nerdtree',
      cmd = { 'NERDTreeFocus', 'NERDTreeToggle' },
    }
    use 'sickill/vim-pasta'
    use {
      'junegunn/goyo.vim',
      cmd = 'Goyo',
      config = function()
        vim.keymap.set('n', '<leader>go', ':Goyo<cr>', { silent = true })
      end,
    }
    use {
      'junegunn/limelight.vim',
      cmd = 'Limelight',
      after = 'goyo.vim',
      config = function()
        vim.g.limelight_conceal_ctermfg = 240
        -- TODO set autocmds for callbacks
        -- https://github.com/junegunn/goyo.vim#callbacks
      end
    }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require'lualine'.setup {
          options = {
            theme = 'dracula',
            section_separators = '',
            component_separators = '|',
          },
        }
      end
    }
    use {
      'itchyny/lightline.vim',
      config = function()
        vim.g.lightline = {
          colorscheme = "dracula",
          active = {
            left = {
              { "mode", "paste" },
              { "gitbranch", "readonly", "filename", "modified" }
            }
          },
          component_function = {
            fileformat = "DevIconsFileformat",
            filetype = "DevIconsFiletype",
            gitbranch = "FugitiveHead"
          }
        }
      end,
      disable = true,
    }
    use {
      'ryanoasis/vim-devicons',
      config = function()
        vim.cmd[[
          function! DevIconsFiletype()
            return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
          endfunction

          function! DevIconsFileformat()
            return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
          endfunction
        ]]
      end,
      disable = true,
    }
    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      config = function()
        vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr>', { silent = true })
      end
    }
    use {
      'ntpeters/vim-better-whitespace',
      config = function()
        vim.g.better_whitespace_enabled = 1
        vim.g.strip_whitespace_on_save  = 1
        vim.g.strip_only_modified_lines = 1
        vim.g.strip_whitespace_confirm  = 0
        vim.g.strip_max_file_size       = 0
        vim.g.better_whitespace_filetypes_blacklist = {
          'diff', 'gitcommit', 'unite', 'qf', 'help',
          'markdown', 'rfc',
        }
      end,
      disable = false,
    }
    use {
      'szw/vim-maximizer',
      config = function()
        vim.keymap.set('n', '<leader>m', ':MaximizerToggle!<cr>', { silent = true})
      end
    }

    use {
      'editorconfig/editorconfig-vim',
      config = function()
        vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
      end
    }

    use "mkitt/tabline.vim"
    use "kyazdani42/nvim-web-devicons"
    if is_linux then
      use "yamatsum/nvim-web-nonicons"
    end

    -- Filetypes
    use {
      'lervag/vimtex',
      ft = 'latex',
      config = function()
        vim.g.vimtex_view_method = 'mupdf'
      end
    }
    use {
      'rust-lang/rust.vim',
      ft = 'rust',
      config = function()
        vim.g.rustfmt_autosave = 1
      end
    }
    use { 'hashivim/vim-terraform', ft = 'terraform', disable = false }
    use { 'udalov/kotlin-vim', ft = 'kotlin' }
    use { 'tweekmonster/gofmt.vim', ft = 'go' }
    use { 'rhysd/vim-llvm', ft = 'llvm' }
    use { 'vim-scripts/nginx.vim', ft = 'nginx' }
    use { 'vim-scripts/html-improved-indentation', ft = 'html' }
    use { 'PotatoesMaster/i3-vim-syntax', ft = 'i3' }
    use { 'baskerville/vim-sxhkdrc', ft = 'sxhkdrc' }
    use { 'pangloss/vim-javascript', ft = { 'javascript', 'javascriptreact' } }
    use { 'MaxMEllon/vim-jsx-pretty', ft = 'javascriptreact' }
    use { 'ap/vim-css-color', ft = 'css' }
    use {
      'bazelbuild/vim-bazel',
      requires = 'google/vim-maktaba',
    }
    use 'towolf/vim-helm'
    use 'direnv/direnv.vim'
    use 'ziglang/zig.vim'
    use 'google/vim-jsonnet'
    use {
      'averms/black-nvim',
      run = ':UpdateRemotePlugins',
    }
    use {
      'jjo/vim-cue',
      ft = 'cue',
    }

    use {
      'EvanQuan/vim-executioner',
      config = function ()
	vim.g['executioner#extensions'] = {py = "python %"}
      end
    }

    -- Editing
    use {
      'preservim/vim-pencil',
      -- cmd = { 'Pencil', 'SoftPencil', 'TogglePencil' },
      pattern = { "mail", "markdown", "tex", "text", "vimwiki" },
      config = function ()
        vim.g['pencil#wrapModeDefault'] = 'soft'
        -- TODO set pencil on filetypes
        local group = vim.api.nvim_create_augroup("pencil", { clear = true })
        vim.api.nvim_create_autocmd({ "filetype" }, {
          pattern = { "mail", "markdown", "tex", "text", "vimwiki" },
          command = "call pencil#init()",
          group = group,
          desc = "Enable pencil on prose filetypes",
        })
      end
    }
    use {
      'junegunn/vim-easy-align',
      config = function()
        vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { remap = true })
        vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { remap = true })
      end
    }
    use {
      'jiangmiao/auto-pairs',
      config = function()
        vim.g.AutoPairsFlyMode = 0
      end
    }
    use {
      'unblevable/quick-scope',
      config = function()
        vim.g.qs_highlight_on_keys = {
          'f', 'F', 't', 'T',
        }
      end
    }
    use 'AndrewRadev/splitjoin.vim'

    use {
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install',
      ft = 'markdown',
    }
    use {
      'shuntaka9576/preview-swagger.nvim',
      run = 'yarn install'
    }

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
      'nvim-telescope/telescope.nvim',
      config = function ()
        require 'dms.telescope'
      end,
      requires = 'nvim-lua/plenary.nvim',
    }
    use {
      'nvim-telescope/telescope-frecency.nvim',
      config = function()
        require'telescope'.load_extension'frecency'
      end,
      requires = { 'tami5/sqlite.lua', },
      after = 'telescope.nvim',
      disable = true,
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      config = function()
        require'telescope'.load_extension'fzf'
      end,
      run = 'make',
      after = 'telescope.nvim',
    }
    use {
      'nvim-telescope/telescope-file-browser.nvim',
      config = function()
        require'telescope'.load_extension'file_browser'
      end,
      disable = false,
    }

    use {
      'ThePrimeagen/harpoon',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require'harpoon'.setup{
          global_settings = {
            mark_branch = true,
          },
          menu = {
            width = math.floor(0.80 * vim.api.nvim_win_get_width(0)),
          },
          mark_branch = true,
        }
        for i=1,4 do
          vim.keymap.set('n', '<leader>'..i, function()
            require'harpoon.ui'.nav_file(i)
          end)
          vim.keymap.set('n', ']h', require'harpoon.ui'.nav_next)
          vim.keymap.set('n', '[h', require'harpoon.ui'.nav_prev)
          vim.keymap.set('n', '<leader>hh', require'harpoon.ui'.toggle_quick_menu)
          vim.keymap.set('n', '<leader>hp', require'harpoon.mark'.add_file)
        end
      end
    }

    use {
      "numToStr/Comment.nvim",
      config = function ()
        require 'Comment'.setup{
          mappings = {
            basic = true,
            extra = true,
            -- extended = true,
          }
        }
      end
    }

    use {
      "hrsh7th/nvim-cmp",
      config = function()
        require'dms.nvim_cmp'
      end
    }
    use { "hrsh7th/cmp-cmdline", disable = true }
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-calc"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-document-symbol"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-emoji"
    use {
      "hrsh7th/cmp-git",
      config = function ()
        require'cmp_git'.setup{
          filetypes = { 'gitcommit' },
          github = {
            issues = {
              filter = "all",
              limit = 100,
              state = "open",
            },
            mentions = {
              limit = 100,
            },
          }
        }
      end
    }
    use {
      "uga-rosa/cmp-dictionary",
      config = function ()
        require'cmp_dictionary'.setup{
          dic = {
            ["*"] = "/usr/share/dict/words",
          },
          first_case_insensitive = true,
        }
      end,
      disable = true,
    }

    use {
      'github/copilot.vim',
      config = function()
        vim.g.copilot_filetypes = {
          ["*"] = true,
        }
      end,
    }

    -- Snippets
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use "tamago324/cmp-zsh"
    use "onsails/lspkind.nvim"
    use "tjdevries/nlua.nvim"

    -- LSP
    use 'neovim/nvim-lspconfig'
    -- use 'nvim-lua/completion-nvim'
    use {
      'j-hui/fidget.nvim',
      tag = 'legacy',
      config = function()
        require'fidget'.setup{}
      end,
    }
    use {
      'williamboman/mason.nvim',
      run = ':MasonUpdate',
      config = function()
        require'mason'.setup{}
      end,
    }

    use 'dstein64/vim-startuptime'

    -- Treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      config = function ()
        require 'dms.treesitter'
      end,
      run = { ':TSInstall all', ':TSUpdate' },
    }
    use 'nvim-treesitter/playground'

    -- misc
    use { 'vim-utils/vim-man', cmd = { 'Man', 'Vman' } }
    use { 'mhinz/vim-rfc', cmd = 'RFC' }

    -- Colors
    use {
      'dracula/vim',
      as = 'dracula',
      config = function()
        vim.g.dracula_colorterm = 0
      end,
    }
    use {
      'catppuccin/nvim',
      as = 'catppuccin',
    }
    use 'dylanaraps/wal.vim'
  end
}
