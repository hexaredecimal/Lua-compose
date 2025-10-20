local State = {}  
  
-- State storage  
local componentStates = {}  
local idStack = {}  
local currentWindowId = nil  
  
-- ID generation and management  
function State.setWindowContext(windowId)  
    currentWindowId = windowId or "global"  
    idStack = {}  
end  
  
function State.pushID(id)  
    table.insert(idStack, tostring(id))  
end  
  
function State.popID()  
    table.remove(idStack)  
end  
  
-- Generate hierarchical ID from stack  
local function generateStateKey(componentId)  
    local parts = {currentWindowId}  
      
    -- Add all stacked IDs  
    for _, stackId in ipairs(idStack) do  
        table.insert(parts, stackId)  
    end  
      
    -- Add component ID  
    table.insert(parts, tostring(componentId))  
      
    return table.concat(parts, ".")  
end  
  
-- Core state management  
function State.of(componentId, initialValue)  
    assert(componentId ~= nil, "useState requires a component ID")  
      
    local stateKey = generateStateKey(componentId)  
      
    -- Initialize state if it doesn't exist  
    if componentStates[stateKey] == nil then  
        componentStates[stateKey] = initialValue  
    end  
      
    -- Getter  
    local function getState()  
        return componentStates[stateKey]  
    end  
      
    -- Setter  
    local function setState(newValue)  
        componentStates[stateKey] = newValue  
    end  
      
    return componentStates[stateKey], setState
end  
  
-- Batch state updates  
function State.batchUpdate(updates)  
    for key, value in pairs(updates) do  
        if componentStates[key] ~= nil then  
            componentStates[key] = value  
        end  
    end  
end  
  
-- Clear state for a specific window or component  
function State.clearState(pattern)  
    if pattern then  
        for key in pairs(componentStates) do  
            if string.match(key, pattern) then  
                componentStates[key] = nil  
            end  
        end  
    else  
        componentStates = {}  
    end  
end  
  
-- Debug utilities  
function State.getStateSnapshot()  
    local snapshot = {}  
    for k, v in pairs(componentStates) do  
        snapshot[k] = v  
    end  
    return snapshot  
end  
  
function State.printState()  
    print("=== State Manager Debug ===")  
    for key, value in pairs(componentStates) do  
        print(string.format("%s = %s", key, tostring(value)))  
    end  
    print("===========================")  
end  
  
return State