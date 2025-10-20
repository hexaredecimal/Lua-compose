if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local StateIndex = require (SLAB_PATH .. 'StateIndex')

local Rememeber = {}  

local componentStates = {}  
local idStack = {}  
local currentWindowId = nil  

local StateValue = {}
StateValue.__index = StateValue

setmetatable(StateValue, {
  __call = function(_, opts)
      local self = setmetatable({}, StateValue)
      self.value = opts.value
      return self
    end,
    
  -- Directly using the variable (number, string, etc.)
  __tostring = function() return tostring(self.value) end,
  __add = function(me, other) return me.value + other end,
  __sub = function(me, other) return me.value - other end,
  __mul = function(me, other) return me.value * other end,
  __div = function(me, other) return me.value / other end,
  __eq = function(me, other) return me.value == other end,
    
})
  

function Rememeber.setWindowContext(windowId)  
    currentWindowId = windowId or "global"  
    idStack = {}  
end  
  
function Rememeber.pushID(id)  
    table.insert(idStack, tostring(id))  
end  
  
function Rememeber.popID()  
    table.remove(idStack)  
end  
  

local function generateStateKey(componentId)  
    local parts = {currentWindowId}  
      
    for _, stackId in ipairs(idStack) do  
        table.insert(parts, stackId)  
    end  

    table.insert(parts, tostring(componentId))  
      
    return table.concat(parts, ".")  
end  

 
function Rememeber.by(props)  
    local stateKey = generateStateKey(StateIndex.next()) 
    
    local value = nil
    if type(props) ~= "table" then  
        value = props
    else 
      for k, v in pairs(props) do  
          if type(k) ~= "number" then  
              hasNamedProps = true  
              break  
          end  
      end 
      
      local arrayLength = #props  
      local hasNamedProps = false  
        

      if arrayLength == 1 and not hasNamedProps then  
          value =  props[1]  
          
      elseif arrayLength > 1 and not hasNamedProps then  
          value = {}
          for _, val in pairs(props) do
            table.insert(value, val)
          end
      end  
    end  
    
    local function setState(newValue)  
        componentStates[stateKey].value = newValue  
    end
    
    local function getState(statekey)  
        return componentStates[stateKey].value 
    end  
    
    local state = StateValue { value = value }
    setmetatable(state, {
      __newindex = function(_, key, val)
        setState(value)
      end,
      __index = function(_, key)
        return getState(key)
      end,
    })
  
    if componentStates[stateKey] == nil then  
      componentStates[stateKey] = state
    end  
      

      
    return componentStates[stateKey]
end  
  


function Rememeber.getStateSnapshot()  
    local snapshot = {}  
    for k, v in pairs(componentStates) do  
        snapshot[k] = v  
    end  
    return snapshot  
end  
  
function Rememeber.printState()  
    print("=== State Manager Debug ===")  
    for key, value in pairs(componentStates) do  
        print(string.format("%s = %s", key, tostring(value)))  
    end  
    print("===========================")  
end  
  
return Rememeber