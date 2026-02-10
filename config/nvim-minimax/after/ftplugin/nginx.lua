
local add, now = MiniDeps.add, MiniDeps.now
now(function()
  add("vim-scripts/nginx.vim")
end)
