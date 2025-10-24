if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local Style = require(SLAB_PATH .. 'Style')
local UI = require(SLAB_PATH .. "UI")
local Later = require(SLAB_PATH .. "Later")
local Remember = require(SLAB_PATH .. "Remember")


local Compose = {}


function Compose.init(args)
  Slab.Initialize(args or {})
end

function Compose.render()
  Later.perform()
  Slab.Draw()
end

function Compose.currentDir()
  local info = debug.getinfo(1, "S").source
  if info:sub(1, 1) == "@" then
    local fullpath = info:sub(2)
    return fullpath:match("(.*/)")
  end
  return nil
end

return Compose
