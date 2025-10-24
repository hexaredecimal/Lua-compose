if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")
local Style = require(SLAB_PATH .. 'Style')

local Image = {}
Image.__index = Image

local function scriptDir()
  local info = debug.getinfo(1, "S").source
  if info:sub(1, 1) == "@" then
    local fullpath = info:sub(2)
    return fullpath:match("(.*/)")
  end
  return nil
end

setmetatable(Image, {
  __call = function(_, opts)
    local self = setmetatable({}, Image)
    self.id = "Image_" .. UI.nextId()
    self.path = opts.path or scriptDir() .. "Internal/Resources/Textures/Transparency.png"
    self.paintResource = opts.paintResource
    self.subX = opts.subX
    self.subY = opts.subY
    self.subWidth = opts.subWidth
    self.subHeight = opts.subHeight
    self.color = opts.color
    self.scale = opts.scale
    self.scaleX = opts.scaleX
    self.scaleY = opts.scaleY
    self.rotation = opts.rotation
    self.hasOutLine = opts.hasOutLine
    self.outlineColor = opts.outlineColor
    self.outlineWidth = opts.outlineWidth
    self.width = opts.width
    self.height = opts.height
    self.onClick = opts.onClick or function() end
    self.onHover = opts.onHover or function() end
    return self
  end
})

function Image:render()
  local options = {
    Rotation     = self.rotation,
    Scale        = self.scale,
    ScaleX       = self.scaleX,
    ScaleY       = self.scaleY,
    Color        = self.color,
    SubX         = self.subX,
    SubY         = self.subY,
    SubH         = self.subHeight,
    SubW         = self.subWidth,
    UseOutline   = self.hasOutLine,
    OutlineColor = self.outlineColor,
    OutlineW     = self.outlineWidth,
    OutlineH     = self.outlineHeight,
    W            = self.width,
    H            = self.height
  }

  if self.paintResource ~= nil then
    options.Image = self.paintResource
  else
    options.Path = self.path
  end

  Slab.Image(self.id, options)
  if Slab.IsControlClicked() then
    self.onClick()
  end

  if Slab.IsControlHovered() then
    self.onHover()
  end
end

return Image
