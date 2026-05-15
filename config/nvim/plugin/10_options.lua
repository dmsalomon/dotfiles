-- ┌──────────────────────────┐
-- │ Built-in Neovim behavior │
-- └──────────────────────────┘
--
-- This file defines Neovim's built-in behavior. The goal is to improve overall
-- usability in a way that works best with MINI.
--
-- Here `opt.xxx = value` sets default value of option `xxx` to `value`.
-- See `:h 'xxx'` (replace `xxx` with actual option name).
--
-- Option values can be customized on a per buffer or window basis.
-- See 'after/ftplugin/' for common example.

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading. Consider preserving this or remove `-- stylua` lines to autoformat.

-- General ====================================================================
vim.g.mapleader = ' ' -- Use `<Space>` as <Leader> key

local opt = vim.opt

opt.mouse       = 'a'            -- Enable mouse
opt.mousescroll = 'ver:25,hor:6' -- Customize mouse scroll
opt.switchbuf   = 'usetab'       -- Use already opened buffers when switching
opt.undofile    = true           -- Enable persistent undo

opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end


-- UI =========================================================================
opt.breakindent    = true       -- Indent wrapped lines to match line start
opt.breakindentopt = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
opt.colorcolumn    = '+1'       -- Draw column on the right of maximum width
opt.cursorline     = false      -- Disable current line highlighting
opt.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
opt.list           = true       -- Show helpful text indicators
opt.number         = true       -- Show line numbers
opt.pumheight      = 10         -- Make popup menu smaller
opt.ruler          = false      -- Don't show cursor coordinates
opt.shortmess      = 'CFOSWaco' -- Disable some built-in completion messages
opt.showmode       = false      -- Don't show mode in command line
opt.signcolumn     = 'yes'      -- Always show signcolumn (less flicker)
opt.splitbelow     = true       -- Horizontal splits will be below
opt.splitkeep      = 'screen'   -- Reduce scroll during window split
opt.splitright     = true       -- Vertical splits will be to the right
opt.winborder      = 'single'   -- Use border in floating windows
opt.wrap           = false      -- Don't visually wrap lines (toggle with \w)
opt.hlsearch       = false

opt.number         = true
opt.relativenumber = true

opt.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
opt.fillchars = 'eob: ,fold:╌'
opt.listchars = 'extends:…,nbsp:␣,precedes:…,tab:> '

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
opt.foldlevel   = 10       -- Fold nothing by default; set to 0 or 1 to fold
opt.foldmethod  = 'indent' -- Fold based on indent level
opt.foldnestmax = 10       -- Limit number of fold levels
opt.foldtext    = ''       -- Show text under fold with its highlighting

-- Editing ====================================================================
opt.autoindent    = true    -- Use auto indent
opt.expandtab     = true    -- Convert tabs to spaces
opt.formatoptions = 'rqnl1j'-- Improve comment editing
opt.ignorecase    = true    -- Ignore case during search
opt.incsearch     = true    -- Show search matches while typing
opt.infercase     = true    -- Infer case in built-in completion
opt.shiftwidth    = 2       -- Use this number of spaces for indentation
opt.smartcase     = true    -- Respect case if search pattern has upper case
opt.smartindent   = true    -- Make indenting smart
opt.spelloptions  = 'camel' -- Treat camelCase word parts as separate words
opt.tabstop       = 2       -- Show tab as this number of spaces
opt.virtualedit   = 'block' -- Allow going past end of line in blockwise mode

opt.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
opt.complete    = '.,w,b,kspell'                  -- Use less sources
opt.completeopt = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
-- opt.wildmode    = "longest:full,full" -- Command-line completion mode

-- Autocommands ===============================================================

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

-- There are other autocommands created by 'mini.basics'. See 'plugin/30_mini.lua'.

-- Diagnostics ================================================================

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
-- See `:h vim.diagnostic` and `:h vim.diagnostic.config()`.
local vds = vim.diagnostic.severity
local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = { priority = 9999, severity = { min = vds.WARN, max = vds.ERROR } },

  -- Show all diagnostics as underline (for their messages type `<Leader>ld`)
  underline = { severity = { min = vds.HINT, max = vds.ERROR } },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,
  virtual_text = {
    current_line = false,
    severity = { min =  vds.WARN },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}


if vim.fn.executable("rg") then
  opt.grepprg = "rg --no-heading --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
-- stylua: ignore end
