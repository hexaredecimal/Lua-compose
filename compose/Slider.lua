
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Slider = {}
Slider.__index = Slider


setmetatable(Slider, {
    __call = function(_, opts)
        local self = setmetatable({}, Slider)
        self.id = "Slider_" .. UI.nextId()
        self.value = tonumber(opts.value) or 0
        self.min = tonumber(opts.min) or 0
        self.max = tonumber(opts.max) or 0
        self.step = tonumber(opts.tostep) or 1.0
        self.onChange = opts.onChange or function(_) end

        return self
    end
})

function Slider:render()
  if Slab.Input(self.id, {
      Text = tostring(self.value), 
      NumbersOnly = true, 
      UseSlider = true,
      MinNumber = self.min,
      MaxNumber = self.max,
      Step = self.step
  }) then
    self.value = Slab.GetInputNumber()
    self.onChange(self.value)
  end
end



return Slider
