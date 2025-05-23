-- presets.lua
-- basic patch preset handler for Eliane

local M = {}

M.saved = {}

function M.save(patch)
  table.insert(M.saved, patch)
end

function M.load(index)
  return M.saved[index] or {}
end

return M
