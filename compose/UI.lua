

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
end

function UI.endDrawing()
    UI.id = 0
end

function UI.pop()
  table.remove(UI.stack)
end

function UI.current()
  return UI.stack[#UI.stack]
end


return UI

