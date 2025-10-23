
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local Remember = require(SLAB_PATH .. "Remember")

local YesNoDialog = {}
YesNoDialog.__index = YesNoDialog


setmetatable(YesNoDialog, {
    __call = function(_, opts)
        local self = setmetatable({}, YesNoDialog)
        self.title = opts.title or "A Message Dialog"
        self.title = tostring(self.title)
        
        self.text = opts.text or ""
        self.text = tostring(self.text)
        self.id = "YesNoDialog_" .. UI.nextId()
        self.show = opts.show or false
        self.onYes = opts.onYes or function() end
        self.onNo = opts.onNo or function() end 
        return self
    end
})

function YesNoDialog:render()
    if self.show then
      local Result = Slab.MessageBox(self.title, self.text, {Buttons = {"Yes", "No"}})
      
      if Result == "Yes" then
        self.onYes()
      elseif Result == "No" then
        self.onNo()
      end
    end
end

return YesNoDialog
