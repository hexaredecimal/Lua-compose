
if SLAB_PATH == nil then
	SLAB_PATH = (...):match("(.-)[^%.]+$")
end

local Slab = require (SLAB_PATH .. 'API')
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

        self.show = true
        self.onResult = opts.onResult or function(_) end
        self.kind = opts.kind or FileDialog.Kind.OpenFile
        
        if self.show then
          local Result = Slab.FileDialog({Type = self.kind})

          if Result ~= "" or Result ~= "Cancel" then
            self.show = false
            self.onResult(Result.Files)
          end
        end
        
        return self
    end
})

function FileDialog:render()
end



return FileDialog
