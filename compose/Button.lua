
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')



local Button = {}
Button.__index = Button

setmetatable(Button, {
  __call = function(_, opts)
    local self = setmetatable({}, Button)
    self.text = opts.text or "Button"
    self.onClick = opts.onClick or function() end
    return self
  end
})

function Button:render()
  if Slab.Button(self.text) then
    self.onClick()
  end

end

return Button

