if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local ContextMenu = {}
ContextMenu.__index = ContextMenu

setmetatable(ContextMenu, {
  __call = function(_, opts)
    local self = setmetatable({}, ContextMenu)
    self.children = {}

    self.text = opts.text or ""
    self.isEnabled = opts.enabled or true

    for _, child in pairs(opts) do
      if type(child) == "table" and child.render then
        table.insert(self.children, child)
      end
    end
    return self
  end
})

function ContextMenu:render()
  if Slab.BeginContextMenuItem() then
    for index, child in pairs(self.children) do
      child:render()
    end

    Slab.EndContextMenu()
  end
end

return ContextMenu
