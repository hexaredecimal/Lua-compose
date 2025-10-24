if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Menu = {}
Menu.__index = Menu

setmetatable(Menu, {
  __call = function(_, opts)
    local self = setmetatable({}, Menu)
    self.children = {}

    self.text = opts.text or ""
    self.isEnabled = opts.enabled or true

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

function Menu:render()
  if Slab.BeginMenu(self.text, { Enabled = self.isEnabled }) then
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

    Slab.EndMenu()
  end
end

return Menu
