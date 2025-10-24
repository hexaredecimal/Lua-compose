if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Separator = {}
Separator.__index = Separator

setmetatable(Separator, {
  __call = function(_, opts)
    local self = setmetatable({}, Separator)
    return self
  end
})

function Separator:render()
  Slab.Separator()
end

return Separator
