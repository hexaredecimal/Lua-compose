if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local List = {}
List.__index = List
List.__count = 0

setmetatable(List, {
  __call = function(_, opts)
    local self = setmetatable({}, List)
    self.items = opts.items or {}
    self.each = opts.each or function(_) end
    self.onSelect = opts.onSelect or function(_) end
    self.selected = 0
    self.id = UI.nextId()
    return self
  end
})

function List:render()
  local listId = "ListBox_" .. self.id

  Slab.BeginListBox(listId)

  for index, item in ipairs(self.items) do
    local isSelected = (self.selected == index)
    local itemId = listId .. "_Item_" .. index

    Slab.BeginListBoxItem(itemId, { Selected = isSelected })

    local child = self.each(item)
    if type(child) == "table" and child.render then
      child:render()
    end

    if Slab.IsListBoxItemClicked() then
      self.selected = index
      self.onSelect(index)
    end

    Slab.EndListBoxItem()
  end

  Slab.EndListBox()
end

return List
