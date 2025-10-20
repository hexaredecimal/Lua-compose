
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local Remember = require(SLAB_PATH .. "Remember")


local Window = {}
Window.__index = Window
Window._initialized = false   -- class-level flag

Window.defaults = {
    width = 100,
    height = 50,
    title = "My Window",
    isOpen = true,
    minimizable = true,
    resizable = true,
    movable = true,
    focusable = true,
    border = 4.0
}

setmetatable(Window, {
    __call = function(_, opts)
        opts = opts or {}
        local self = setmetatable({}, Window)

        self.width    = opts.width    or Window.defaults.width
        self.height   = opts.height   or Window.defaults.height
        self.title    = opts.title    or Window.defaults.title
        self.isOpen = opts.isOpen or Window.defaults.isOpen
        self.minimizable = opts.minimizable or Window.defaults.minimizable
        self.resizable = opts.resizable or Window.defaults.resizable
        self.movable = opts.movable or Window.defaults.movable
        self.focusable = opts.focusable or Window.defaults.focusable
        self.bgColor = opts.bgColor
        self.border = opts.border or Window.defaults.border


        self.id = opts.id or "Window_" .. UI.nextId()
        self.children = {}
        Remember.setWindowContext(self.title) 

        
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

function Window:render()
  
  Slab.BeginWindow(self.id, {
    Title = self.title, 
    IsOpen = self.isOpen,
    ShowMinimize = self.minimizable,
    AutoSizeWindow = self.resizable,
    W = self.width,
    H = self.height,
    AllowResize = self.resizable,
    AllowFocus = self.focusable,
    AllowMove = self.movable,
    BgColor = self.bgColor,
    Border = self.border
  })


  UI.push(self)
  
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
  
  UI.pop()
  
  Slab.EndWindow()
end 

return Window
