
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local Style = require (SLAB_PATH .. 'Style')
local UI = require(SLAB_PATH .. "UI")
local Later = require(SLAB_PATH .. "Later")
local Remember = require(SLAB_PATH .. "Remember")


local App = {}
App.__index = App


setmetatable(App, {
    __call = function(_, opts)
        opts = opts or {}
        local self = setmetatable({}, App)

        local dt = love.timer.getDelta()

        Slab.Update(dt)
        Later.reset()
        Remember.setWindowContext("AppState_") 
      
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
