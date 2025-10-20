# LUA Compose
>> A declarative API for Slab UI library. 

## Why?
- I wanted a declarative style UI for my love2d project. 
- I wanted reactive state management for the UI. 
- I had too much time

## Example
```lua
-- A Basic count-up app inspired by ReactJS

function counterAppWindow() 
  local width = 250
  local height = 150
  local count, setCount = State.of("Counter Example", 0) -- You have to provide your own state id. :(
    
  return Window {
    width = width,
    height = height,
    title = "Simple form",
    
    Button {
      text = "Count: " .. count,
      onClick = function()
        setCount(count + 1)
      end
    }
  }
end
```

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
