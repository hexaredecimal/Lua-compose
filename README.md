# LUA Compose
>> A declarative API for Slab UI library. 

## Why?
- I wanted a declarative style UI for my love2d project. 
- I wanted reactive state management for the UI. 
- I had too much time

## Example
```lua
-- A Basic count-up app inspired by Jetpack compose

function counterAppWindow() 
  local width = 250
  local height = 150
  local count = Remember.by { 0 } 
    
  return Window {
    width = width,
    height = height,
    title = "Simple form",
    
    Button {
      text = "Count: " .. count.value,
      onClick = function()
        count.value = count.value + 1
      end
    }
  }
end
```


<img width="60%"  alt="image" src="https://github.com/user-attachments/assets/709f3ed9-9ee6-426c-aeb5-efc50a810a07" />


Here is a bigger example. An implementation of a simple form. 

```
local App = require "compose.App"
local Window = require "compose.Window"
local Button = require "compose.Button"
local Text = require "compose.Text"
local Row = require "compose.Row"
local Input = require "compose.Input"
local CheckBox = require "compose.CheckBox"

local Remember = require "compose.Remember"

function combineInfo(username, email, password)
  return 
    "Username: " .. username.value .. "\n"
    .. "Email: " .. email.value .. "\n"
    .. "Password: " .. password.value .. "\n"
end

function simpleFormApp() 
      
  local username = Remember.by { "" } 
  local email = Remember.by { "" }
  local password = Remember.by { "" }
  local agreeToConditions = Remember.by { false }
  
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

```


<img width="60%" alt="image" src="https://github.com/user-attachments/assets/cc60e34c-9bf3-4b28-a4b0-36396bd3b402" />



# Installation
```lua
-- Clone git@github.com:hexaredecimal/Lua-compose.git and copy the "compose" subdirectory into your project source root.
-- In other words put "compose" near your "main.lua" file or where it will be imported.
-- Then simply do:

local Window = require "compose.Window"
local Button = require "compose.Button"
-- etc for each component you need. 

Window {
  width = 200,
  height = 150, 

  Button { text = "Click Me" }
}

```

# Features: 
- [x] Declarative API
- [X] State Management
- [X] Callback based event system (Elements such as Buttons have onClick callback functions, etc)

# Todo
- [ ] Testing

# References
- Todo:
