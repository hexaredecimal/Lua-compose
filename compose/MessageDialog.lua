
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local State = require(SLAB_PATH .. "State")

local MessageDialog = {}
MessageDialog.__index = MessageDialog


setmetatable(MessageDialog, {
    __call = function(_, opts)
        local self = setmetatable({}, MessageDialog)
        self.title = opts.title or ""
        self.title = tostring(self.title)
        
        self.text = opts.text or ""
        self.text = tostring(self.text)
        local show, setShow = State.of(self.title, true)
        self.onClose = opts.onClose or function() end
        
        if show then
          local Result = Slab.MessageBox(self.title, self.text)

          if Result ~= "" then
            setShow(false)
            self.onClose()
          end
        end
        
        return self
    end
})

function MessageDialog:render()
end



return MessageDialog
