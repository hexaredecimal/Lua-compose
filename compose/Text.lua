
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')

local Text = {}
Text.__index = Text

setmetatable(Text, {
  __call = function(_, opts)
    local self = setmetatable({}, Text)
    self.text = opts.text or ""
    self.isSelectable = opts.isSelectable or false
    self.url = opts.url or nil
    return self
  end
})

function Text:render()
  if self.isSelectable then
    if Slab.TextSelectable(self.text) then 
      if self.onSelect ~= nil then 
        self.onSelect()
      end
    end
  else
    Slab.Text(self.text, {URL = self.url})
  end
end

return Text

