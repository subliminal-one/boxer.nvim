local M = {}

M.get_coords = function(line)
  return line:find('- %[[%s%.x]%]')
end

return M
