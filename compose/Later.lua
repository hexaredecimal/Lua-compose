if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')

local Later = { drawCalls = {} }

function Later.reset()
  Later.drawCalls = {}
end

function Later.draw(func)
  assert(type(func) == "function", "Expected a function to be passed as an argument to Later.draw")
  table.insert(Later.drawCalls, func)
end

function Later.perform(func)
  for _, func in ipairs(Later.drawCalls) do
    func()
  end
end

return Later
