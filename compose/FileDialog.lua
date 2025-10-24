if SLAB_PATH == nil then
  SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require(SLAB_PATH .. 'API')
local UI = require(SLAB_PATH .. "UI")

local FileDialog = {}
FileDialog.__index = FileDialog

FileDialog.Kind = {
  OpenFile = "openFile",
  OpenDirectory = "opendirectory",
  SaveFile = "saveFile"
}

setmetatable(FileDialog, {
  __call = function(_, opts)
    local self = setmetatable({}, FileDialog)

    self.show = opts.show or false
    self.onResult = opts.onResult or function(_) end
    self.onCancel = opts.onCancel or function(_) end
    self.kind = opts.kind or FileDialog.Kind.OpenFile
    self.filters = opts.filters
    self.directory = opts.directory or love.filesystem.getSourceBaseDirectory()


    return self
  end
})

function FileDialog:render()
  if self.show then
    local Result = Slab.FileDialog({
      Type = self.kind,
      Filters = self.filters,
      Directory = self.directory
    })

    if Result.Button == "Result" or #Result.Files > 0 then
      self.onResult(Result.Files)
    elseif Result.Button == "Cancel" then
      self.onCancel(not self.show)
    end
  end
end

return FileDialog
