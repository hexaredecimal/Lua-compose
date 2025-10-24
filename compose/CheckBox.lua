if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local CheckBox = {}
CheckBox.__index = CheckBox


setmetatable(CheckBox, {
  __call = function(_, opts)
    local self = setmetatable({}, CheckBox)
    self.text = opts.text or ""
    self.text = tostring(self.text)
    self.value = opts.value or false;
    self.onToggle = opts.onToggle or function(_) end
    return self
  end
})

function CheckBox:render()
  if Slab.CheckBox(self.value, self.text)
  then
    self.value = not self.value
    self.onToggle(self.value)
  end
end

return CheckBox
