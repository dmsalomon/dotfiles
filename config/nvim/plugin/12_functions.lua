
_G.list_installed_packages = function()
  return vim.iter(vim.pack.get())
    :map(function(p) return p.spec.name end)
    :totable()
end

_G.list_inactive_packages = function()
  return vim.iter(vim.pack.get())
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()
end

_G.delete_inactive_package = function()
  local to_del = _G.list_inactive_packages()
  vim.pack.del(to_del)
end
