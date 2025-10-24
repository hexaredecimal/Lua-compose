if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Void = {}
Void.__index = Void
Void._initialized = false -- class-level flag


setmetatable(Void, {
  __call = function(_, opts)
    opts = opts or {}
    local self = setmetatable({}, Void)
    UI.push(self)
    for _, child in pairs(opts) do
      if type(child) == "table" and child.render then
        child:render()
      elseif type(child) == "function" then
        child()
      end
    end
    UI.pop()
    return self
  end
})

return Void
