if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local StateIndex = require (SLAB_PATH .. 'StateIndex')

local UI = {
  stack = {},
  id = 0
}

function UI.push(obj)
  table.insert(UI.stack, obj)
end

function UI.nextId()
    UI.id = UI.id + 1
    return "ui_" .. UI.id
end

function UI.beginDrawing()
    UI.id = 0
    StateIndex.reset()
end

function UI.endDrawing()
    UI.id = 0
    StateIndex.reset()
end

function UI.pop()
  table.remove(UI.stack)
end

function UI.current()
  return UI.stack[#UI.stack]
end


return UI

