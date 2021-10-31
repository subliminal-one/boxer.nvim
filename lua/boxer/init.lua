local utils = require('boxer.utils')
local M = {}

local function create(content)
  content = content or ' '

  local line = vim.api.nvim_get_current_line()
  local x, y = utils.get_coords(line)

  if x ~= nil then
    return
  end

  local box  = string.format(' [%s] ', content)
  local list = line:find('- ')

  -- Handle lines that are already lists
  if list ~= nil then
    local output = line:sub(1, list) .. box .. line:sub(list + 2)
    vim.api.nvim_set_current_line(output)
    return
  end

  -- Find the first character on the line
  local start = line:find('[%a|%d]')

  if start == nil then
    print('unable to find starting position')
    return
  end

  local output = line:sub(1, start - 1) .. '-' .. box .. line:sub(start)
  vim.api.nvim_set_current_line(output)
end

M.open = function(line)
  line = line or vim.api.nvim_get_current_line()
  local x, y = utils.get_coords(line)

  if x == nil then
    create(' ')
    return
  end

  local output = line:sub(1, x - 1) ..  '- [ ]' .. line:sub(y + 1)
  vim.api.nvim_set_current_line(output)
end

M.pending = function(line)
  line = line or vim.api.nvim_get_current_line()
  local x, y = utils.get_coords(line)

  if x == nil then
    create('.')
    return
  end

  local output = line:sub(1, x - 1) ..  '- [.]' .. line:sub(y + 1)
  vim.api.nvim_set_current_line(output)
end

M.complete = function(line)
  line = line or vim.api.nvim_get_current_line()
  local x, y = utils.get_coords(line)

  if x == nil then
    create('x')
    return
  end

  local output = line:sub(1, x - 1) ..  '- [x]' .. line:sub(y + 1)
  vim.api.nvim_set_current_line(output)
end

-- Currently unbound
M.cycle = function()
  local line = vim.api.nvim_get_current_line()
  local x,y

  x,y = utils.get_coords(line)
  if x == nil then
    create(' ')
    return
  end

  local operator = line:sub(x + 3, y - 1)

  if operator == ' ' then
    M.pending(line)
    return
  end

  if operator == '.' then
    M.complete(line)
    return
  end

  if operator == 'x' then
    M.open(line)
    return
  end
end

M.delete = function()
  local line = vim.api.nvim_get_current_line();
  local x, y = utils.get_coords(line)

  local output = line:sub(1, x - 1) .. '-' .. line:sub(y + 1)
  vim.api.nvim_set_current_line(output)
end

return M
