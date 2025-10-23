local Window = require "compose.Window"
local App = require "compose.App"
local Slider = require "compose.Slider"
local Text = require "compose.Text"

local Remember = require "compose.Remember"
local Slab = require 'compose.API'

function love.load(args)
	love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	Slab.Initialize(args)
end

function love.update(dt)
  local volumeAmount = Remember.by { 30 } 
  
  App {
    Window {
      Text { text = "Volume: " .. volumeAmount.value .. "%" },
      Slider { 
        min = 1, 
        max = 100, 
        step = 1,
        value = volumeAmount.value,
        onChange = function(newValue)
          volumeAmount.value = newValue
        end
      }
    }
  }
  
end

function love.draw()
	Slab.Draw()
end
