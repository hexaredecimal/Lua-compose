
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Row = {}
Row.__index = Row

setmetatable(Row, {
    __call = function(_, opts)
        local self = setmetatable({}, Row)
        self.children = {}
        self.growHorizontally = opts.growHorizontally or false
        self.growVertically = opts.growVertically or true
        
        self.id = "Row_" .. UI.nextId()
        
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

function Row:render()
  local count = #self.children
  
  Slab.BeginLayout(self.id, {
    Columns = count,
    ExpandW = self.growHorizontally,
    ExpandH = self.growVertically
  })
  
    for index, child in pairs(self.children) do
      Slab.SetLayoutColumn(index)
      if type(child) == "table" and child.render then
        child:render()
      elseif type(child) == "function" then
        local result = child()
        if type(result) == "table" and result.render then
          result:render()
        end
      end
    end
  
  Slab.EndLayout()
end

return Row
