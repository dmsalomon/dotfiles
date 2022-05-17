local M = {}

P = function(v)
  print(vim.inspect(v))
  return v
end

local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
  reloader = require
else
  reloader = plenary_reload.reload_module
end

RELOAD = function(...)
  return reloader(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

function M.has(x)
  return vim.fn.has(x) == 1
end

function M.isdirectory(x)
  return vim.fn.isdirectory(vim.fn.expand(x)) == 1
end

local function toTable(a)
  if type(a) ~= "table" then
    return { a }
  else
    return a
  end
end

function M.enable (a)
  for _, o in ipairs(toTable(a)) do
    vim.opt[o] = true
  end
end

function M.disable(a)
  for _, o in ipairs(toTable(a)) do
    vim.opt[o] = false
  end
end

return M
