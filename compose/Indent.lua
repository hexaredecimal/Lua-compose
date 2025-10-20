
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local Style = require(SLAB_PATH .. 'Style')

local Indent = {}
Indent.__index = Indent

setmetatable(Indent, {
    __call = function(_, opts)
        local self = setmetatable({}, Indent)
        self.children = {}
        self.depth = opts.depth
        if self.depth ~= nil then
          self.depth = tonumber(self.depth) or Style.Style.Indent
        end
        
        for _, child in pairs(opts) do
          if type(child) == "table" and child.render then
            table.insert(self.children, child)
          end
        end
        return self
    end
})

function Indent:render()

  Slab.Indent(self.depth)
  
    for index, child in pairs(self.children) do
      child:render()
    end
  
  Slab.Unindent()
end

return Indent
