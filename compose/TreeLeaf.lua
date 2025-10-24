if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local TreeLeaf = {}
TreeLeaf.__index = TreeLeaf

setmetatable(TreeLeaf, {
  __call = function(_, opts)
    local self = setmetatable({}, TreeLeaf)
    self.id = UI.nextId()
    self.text = opts.text or ("Leaf " .. self.id)
    self.onClick = opts.onClick or function() end
    return self
  end
})

function TreeLeaf:render()
  local treeId = "Tree_" .. self.id
  if Slab.BeginTree(treeId, { Label = self.text, IsLeaf = true }) then
    self.onClick()
  end
end

return TreeLeaf
