
local StateIndex = {
  id = 0
}

function StateIndex.reset()
    StateIndex.id = 0
end

function StateIndex.next()
    local index = "State_" .. StateIndex.id
    StateIndex.id = StateIndex.id + 1
    return index
end

return StateIndex