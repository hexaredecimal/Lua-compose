local Window = require "compose.Window"
local Button = require "compose.Button"
local Text = require "compose.Text"
local List = require "compose.List"
local CheckBox = require "compose.CheckBox"
local Input = require "compose.Input"
local App = require "compose.App"
local Row = require "compose.Row"

local MessageDialog = require "compose.MessageDialog"

local Remember = require "compose.Remember"


local Slab = require 'compose.API'

function love.load(args)
	love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	Slab.Initialize(args)
end

function combineInfo(username, email, password)
  return 
    "Username: " .. username.value .. "\n"
    .. "Email: " .. email.value .. "\n"
    .. "Password: " .. password.value .. "\n"
end

function simpleFormApp() 
      
  local username = Remember.by{ "" } 
  local email = Remember.by { "" }
  local password = Remember.by{ "" }
  local agreeToConditions = Remember.by{ false }
  
  local showDialog = Remember.by{ false }
    
  return Window {
    width = 300,
    height = 90,
    title = "Simple form",
    resizable = false,

    
    Row {
      Text { text = "Username" },
      Input { 
        kind = Input.Kind.Text, value = username.value,
        onChange = function(text)
          username.value = text
        end
      } 
    }, 
    Row {
      Text { text = "Email" },
      Input { 
        kind = Input.Kind.Text, value = email.value,
        onChange = function(text)
          email.value = text
        end
      } 
    }, 
    Row {
      Text { 
        text = "Password"},
      Input { 
        kind = Input.Kind.Text, 
        isPassword = true,
        value = password.value,
        onChange = function(text)
          password.value = text
        end
      } 
    },
    Row {
      CheckBox { 
        text = "Agree to t's and c's",
        value = agreeToConditions.value,
        onToggle = function(value)
          agreeToConditions.value = value
        end
      },
      Button { 
        text = "Sign up",
        onClick = function()
          showDialog.value = true
        end
      },
      
      MessageDialog { 
        title = "Info", 
        text = combineInfo(username, email, password),
        show = showDialog.value,
        onClose = function(value)
          showDialog.value = false
        end
      }
    }
  }
end


function love.update(dt)
  App {
    simpleFormApp,
  }
end

function love.draw()
	Slab.Draw()
end
