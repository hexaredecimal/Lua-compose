if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local Remember = require(SLAB_PATH .. "Remember")

local MessageDialog = {}
MessageDialog.__index = MessageDialog


setmetatable(MessageDialog, {
  __call = function(_, opts)
    local self = setmetatable({}, MessageDialog)
    self.title = opts.title or "A Message Dialog"
    self.title = tostring(self.title)

    self.text = opts.text or ""
    self.text = tostring(self.text)
    self.id = "MessageDialog_" .. UI.nextId()
    self.show = opts.show or false
    self.onClose = opts.onClose or function() end
    return self
  end
})

function MessageDialog:render()
  if self.show then
    local Result = Slab.MessageBox(self.title, self.text)
    if Result ~= "" then
      self.onClose()
    end
  end
end

return MessageDialog
