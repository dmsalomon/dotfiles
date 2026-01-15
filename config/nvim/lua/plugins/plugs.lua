return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "dracula",
		},
	},
	-- Tpope
	"tpope/vim-surround",
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"tpope/vim-eunuch",
	"tpope/vim-sensible",
	"tpope/vim-repeat",
	"tpope/vim-unimpaired",
	"tpope/vim-endwise",
	"tpope/vim-abolish",
	"tpope/vim-speeddating",
	"tpope/vim-characterize",

	-- Window
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = function()
			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<cr>", { silent = true })
		end,
	},
	{
		"ntpeters/vim-better-whitespace",
		config = function()
			vim.g.better_whitespace_enabled = 1
			-- vim.g.strip_whitespace_on_save  = 1
			vim.g.strip_only_modified_lines = 1
			vim.g.strip_whitespace_confirm = 0
			vim.g.strip_max_file_size = 0
			vim.g.better_whitespace_filetypes_blacklist = {
				"diff",
				"gitcommit",
				"unite",
				"qf",
				"help",
				"markdown",
				"rfc",
			}
		end,
	},
	{
		"szw/vim-maximizer",
		config = function()
			vim.keymap.set("n", "<leader>m", ":MaximizerToggle!<cr>", { silent = true })
		end,
	},

	{
		"editorconfig/editorconfig-vim",
		config = function()
			vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
		end,
	},

	"mkitt/tabline.vim",
	-- Filetypes
	{
		"lervag/vimtex",
		-- ft = 'tex',
		config = function()
			vim.g.vimtex_view_method = "mupdf"
		end,
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		config = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{ "hashivim/vim-terraform", ft = "terraform", disable = false },
	{ "udalov/kotlin-vim", ft = "kotlin" },
	{ "tweekmonster/gofmt.vim", ft = "go" },
	{ "rhysd/vim-llvm", ft = "llvm" },
	{ "vim-scripts/nginx.vim", ft = "nginx" },
	{ "vim-scripts/html-improved-indentation", ft = "html" },
	{ "PotatoesMaster/i3-vim-syntax", ft = "i3" },
	{ "baskerville/vim-sxhkdrc", ft = "sxhkdrc" },
	{ "pangloss/vim-javascript", ft = { "javascript", "javascriptreact" } },
	{ "MaxMEllon/vim-jsx-pretty", ft = "javascriptreact" },
	{ "ap/vim-css-color", ft = "css" },
	-- {
	-- 	'bazelbuild/vim-bazel',
	-- 	requires = 'google/vim-maktaba',
	-- },
	"towolf/vim-helm",
	"direnv/direnv.vim",
	"ziglang/zig.vim",
	"google/vim-jsonnet",
	{
		"averms/black-nvim",
		build = ":UpdateRemotePlugins",
	},
	{
		"jjo/vim-cue",
		ft = "cue",
	},

	{
		"EvanQuan/vim-executioner",
		config = function()
			vim.g["executioner#extensions"] = { py = "python %" }
		end,
	},

	-- Editing
	{
		"preservim/vim-pencil",
		-- cmd = { 'Pencil', 'SoftPencil', 'TogglePencil' },
		pattern = { "mail", "markdown", "tex", "text", "vimwiki" },
		config = function()
			vim.g["pencil#wrapModeDefault"] = "soft"
			-- TODO set pencil on filetypes
			local group = vim.api.nvim_create_augroup("pencil", { clear = true })
			vim.api.nvim_create_autocmd({ "filetype" }, {
				pattern = { "mail", "markdown", "tex", "text", "vimwiki" },
				command = "call pencil#init()",
				group = group,
				desc = "Enable pencil on prose filetypes",
			})
		end,
	},
	{
		"junegunn/vim-easy-align",
		config = function()
			vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { remap = true })
			vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { remap = true })
		end,
	},
	{
		"unblevable/quick-scope",
		init = function()
			vim.g.qs_highlight_on_keys = {
				"f",
				"F",
				"t",
				"T",
			}
		end,
	},
	"AndrewRadev/splitjoin.vim",

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
		ft = "markdown",
	},
	{
		"shuntaka9576/preview-swagger.nvim",
		build = "yarn install",
	},

	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{ "vim-utils/vim-man", cmd = { "Man", "Vman" } },
	{ "mhinz/vim-rfc", cmd = "RFC" },

	"folke/which-key.nvim",

	{
		"dracula/vim",
		as = "dracula",
		config = function()
			vim.g.dracula_colorterm = 0
		end,
	},
	"shaunsingh/nord.nvim",
	{
		"catppuccin/nvim",
		as = "catppuccin",
	},
	"dylanaraps/wal.vim",
}
