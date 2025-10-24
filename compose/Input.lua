if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local Input = {}
Input.__index = Input

Input.Kind = {
  Text = "text",
  Number = "number"
}

setmetatable(Input, {
  __call = function(_, opts)
    local self = setmetatable({}, Input)
    self.id = "Input_" .. UI.nextId()
    self.value = opts.value or ""
    self.kind = opts.kind or Input.Kind.Text
    self.isPassword = opts.isPassword or false
    self.min = tonumber(opts.min) or 0
    self.max = tonumber(opts.max) or 0
    self.readOnly = opts.readOnly or false
    self.onChange = opts.onChange or function(_) end

    return self
  end
})

function Input:render()
  local isNumber = self.kind == Input.Kind.Number
  local options = {
    Text = tostring(self.value),
    NumbersOnly = isNumber,
    ReadOnly = self.readOnly,
    IsPassword = self.isPassword
  }

  if isNumber then
    options.MinNumber = self.min
    options.MaxNumber = self.max
  end

  if Slab.Input(self.id, options) then
    if self.kind == Input.Kind.Number then
      self.value = Slab.GetInputNumber()
    else
      self.value = Slab.GetInputText()
    end

    self.onChange(self.value)
  end
end

return Input
