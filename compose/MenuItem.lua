
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local MenuItem = {}
MenuItem.__index = MenuItem

setmetatable(MenuItem, {
    __call = function(_, opts)
        local self = setmetatable({}, MenuItem)
        self.text = opts.text or ""
        self.isEnabled = opts.enabled or true
        self.shortCut = opts.shortCut
        self.onClick = opts.onClick or function() end
        if self.shortCut ~= nil then
          self.shortCut = tostring(self.shortCut)
        end
        
        for _, child in pairs(opts) do
          if type(child) == "table" and child.render then
            table.insert(self.children, child)
          end
        end
        return self
    end
})

function MenuItem:render()

  if Slab.MenuItem(self.text, { Enabled = self.isEnabled, Hint = self.shortCut }) then
    self.onClick()
  end
  
end

return MenuItem
