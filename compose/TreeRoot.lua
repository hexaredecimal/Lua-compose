
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local TreeRoot = {}
TreeRoot.__index = TreeRoot

setmetatable(TreeRoot, {
    __call = function(_, opts)
        local self = setmetatable({}, TreeRoot)
        self.children = {}
        self.id = UI.nextId()
        self.text = opts.text or "Root " .. self.id
        

        
        for _, child in pairs(opts) do
          if type(child) == "table" and child.render then
            table.insert(self.children, child)
          end
        end
        return self
    end
})

function TreeRoot:render()
  local treeId = "Tree_" .. self.id
  if Slab.BeginTree(treeId, {Label = self.text}) then
    for index, child in pairs(self.children) do
      child:render()
    end
    Slab.EndTree()
  end
  
end

return TreeRoot
