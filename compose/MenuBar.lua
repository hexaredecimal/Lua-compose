
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local MenuBar = {}
MenuBar.__index = MenuBar

setmetatable(MenuBar, {
    __call = function(_, opts)
        local self = setmetatable({}, MenuBar)
        self.children = {}
        for _, child in pairs(opts) do
          if type(child) == "table" and child.render then
            table.insert(self.children, child)
          elseif type(child) == "function" then
            table.insert(self.children, child)
          end
        end
        return self
    end
})

function MenuBar:render()
  if Slab.BeginMainMenuBar() then
  
    for index, child in pairs(self.children) do
      if type(child) == "table" and child.render then
        child:render()
      elseif type(child) == "function" then
        local result = child()
        if type(result) == "table" and result.render then
          result:render()
        end
      end
    end
          
    Slab.EndMainMenuBar()
  end
end

return MenuBar
