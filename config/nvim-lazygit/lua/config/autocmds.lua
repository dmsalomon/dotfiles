local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

local au = function(events, pattern, action, arg)
	local opts = {}
	if type(action) == "function" then
		opts.callback = action
	else
		opts.command = action
	end
	vim.api.nvim_create_autocmd(
		events,
		vim.tbl_extend("force", arg or {}, {
			pattern = pattern,
			group = augroup,
		}, opts)
	)
end

vim.api.nvim_create_autocmd("filetype", {
	pattern = "help",
	callback = function()
		vim.keymap.set("n", "<cr>", "<c-]>", { silent = true, buffer = true })
		vim.keymap.set("n", "<bs>", "<c-T>", { silent = true, buffer = true })
		vim.keymap.set("n", "q", ":q!<cr>", { silent = true, buffer = true })
	end,
	group = augroup,
})

au({ "BufRead", "BufNewFile" }, "/etc/nginx/sites-*/*", "set ft=nginx")
au({ "BufRead", "BufNewFile" }, { "*.tf", "*.hcl" }, "set ft=terraform")
au({ "BufRead", "BufNewFile" }, "*.tpl", "set ft=helm")
au("BufWritePost", { "*Xresources", "*Xdefaults" }, "!xrdb -merge %")
au("BufWritePost", "*sxhkdrc", "!pkill -USR1 sxhkd")
au("BufWritePre", "*.tf", vim.lsp.buf.format, { desc = "LSP format" })
