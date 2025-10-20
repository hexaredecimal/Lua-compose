
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local State = require(SLAB_PATH .. "State")


local App = {}
App.__index = App
App._initialized = false   -- class-level flag


setmetatable(App, {
    __call = function(_, opts)
        opts = opts or {}
        local self = setmetatable({}, App)

        local dt = love.timer.getDelta()

        Slab.Update(dt)
        
        State.setWindowContext("App State") 
      
        UI.push(self)
        UI.beginDrawing()
        for _, child in pairs(opts) do
          if type(child) == "table" and child.render then
            child:render()
          elseif type(child) == "function" then
            local result = child()
            if type(result) == "table" and result.render then
              result:render()
            end
          end
        end
        UI.endDrawing()
        UI.pop()
        
        return self
    end
})

return App
