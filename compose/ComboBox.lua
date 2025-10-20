if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local ComboBox = {}
ComboBox.__index = ComboBox
ComboBox.__count = 0

setmetatable(ComboBox, {
  __call = function(_, opts)
    local self = setmetatable({}, ComboBox)
    self.items = opts.items or {}
    self.onSelect = opts.onSelect or function(_) end
    self.selected = opts.selected or ""
    self.id = UI.nextId()
    return self
  end
})

function ComboBox:render()
  local comboId = "ComboBox_" .. self.id
  
  if Slab.BeginComboBox(comboId, {Selected = self.selected}) then
  
    for index, item in ipairs(self.items) do

      if Slab.TextSelectable(tostring(item)) then
        self.selected = index
        self.onSelect(index)
      end

    end
    
    Slab.EndComboBox()
  end 

end

return ComboBox
