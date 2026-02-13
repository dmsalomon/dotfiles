require("config.lazy")

-- python3
local py3venv = vim.fn.expand("~/.local/share/nvim/site/py3nvim/bin")
if vim.fn.isdirectory(py3venv) then
	vim.g.python3_host_prog = py3venv .. "/python"
end

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.cmd([[ highlight WinSeparator guibg=None ]])
