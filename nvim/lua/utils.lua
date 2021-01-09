--- Pretty print for NVIM's Lua API.
--
-- @param obj A Lua object.
-- @usage
-- local buf = vim.api.nvim_list_bufs()
-- PP(buf)
--
-- -- from the vim command-line, call `lua PP(buf)`
--
-- @return the input object itself.
function PP(obj)
  print(vim.inspect(obj))
  return obj
end
