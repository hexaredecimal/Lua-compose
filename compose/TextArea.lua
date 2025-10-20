
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local TextArea = {}
TextArea.__index = TextArea

setmetatable(TextArea, {
    __call = function(_, opts)
        local self = setmetatable({}, TextArea)
        self.id = "TextArea_" .. UI.nextId()
        self.value = ""
        self.highlight = opts.highlight
        self.onChange = opts.onChange or function(_) end
        self.width = opts.width or 100
        self.height = opts.height or 100
        self.readOnly = opts.readOnly or false
        return self
    end
})

function TextArea:render()

  if Slab.Input(self.id, {
      MultiLine = true, 
      Highlight = self.highlight,
      W = self.width,
      H = self.height,
      ReadOnly = self.readOnly
  }) then
    self.value = Slab.GetInputText()
    self.onChange(self.value)
  end

end



return TextArea
