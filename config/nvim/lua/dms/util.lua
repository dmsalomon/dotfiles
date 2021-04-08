
local module = {}

function module.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

vim.fn.system('echo nice >> /tmp/a.txt')

return module
