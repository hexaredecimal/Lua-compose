local Window = require "compose.Window"
local App = require "compose.App"
local Slider = require "compose.Slider"
local Text = require "compose.Text"
local Row = require "compose.Row"
local Column = require "compose.Column"
local Button = require "compose.Button"
local Image = require "compose.Image"
local List = require "compose.List"
local YesNoDialog = require "compose.YesNoDialog"
local MessageDialog = require "compose.MessageDialog"


local MenuBar = require "compose.MenuBar"
local Menu = require "compose.Menu"
local ContextMenu = require "compose.ContextMenu"
local MenuItem = require "compose.MenuItem"
local Separator = require "compose.Separator"

local Later = require "compose.Later"


local FileDialog = require "compose.FileDialog"

local Remember = require "compose.Remember"
local Compose = require 'compose.Compose'

local SlabDebug = require "compose.SlabDebug"

function love.load(args)
  local high = 255 - 60
	love.graphics.setBackgroundColor(high / 255, high / 255, high / 255)
	Compose.init()
end

function openFile(ctx)  
  local imageFilters = {
    { "*.png", "Png Files" },
    { "*.jpg", "Jpg Files" },
    { "*.jpeg", "Jpeg Files" },
    { "*.*", "All Files" }
  }
  
  function loadFromDir(folder)
    local filesTable = love.filesystem.getDirectoryItems(folder)
    local innerFiles = {}
    for i,v in ipairs(filesTable) do
      local file = v
      local info = love.filesystem.getInfo(file)
      if info then
        if info.type == "file" then
          table.insert(innerFiles, file)
        end
      end
    end
    return innerFiles
  end

  local function processFiles(files)
    local size = #files
    if size == 1 then
      local file = files[1]
      if love.filesystem.isDirectory( file ) then
        local loadedFiles = loadFromDir(file)
        local images = {}
        for _,v in ipairs(loadedFiles) do
          table.insert(images, love.graphics.newImage( v ))
        end
        return images
      else 
        return { love.graphics.newImage( file ) }
      end
    end
    
    local images = {}
    for _, imageFile in ipairs(files) do
      local image = love.graphics.newImage(imageFile)
      table.insert(images, image)
    end
    return images
  end
  
  local function processDirs(files)
    local size = #files
    if size == 1 then
      local file = files[1]
      if love.filesystem.isDirectory( file ) then
        local loadedFiles = loadFromDir(file)
        return loadedFiles
      else 
        return { files[1] }
      end
    end
    
    local images = {}

    for _, imageFile in ipairs(files) do
      table.insert(images, imageFile)
    end
    return images
  end
  
  local kind = nil
  
  if ctx.showOpenFileDialog.value then
    kind = FileDialog.Kind.OpenFile
  else
    kind = FileDialog.Kind.OpenDirectory
  end
  
  return FileDialog {
    show = ctx.showOpenFileDialog.value and ctx.showOpenFileDialog.value or ctx.showOpenDirDialog.value,
    kind = kind, 
    filters = imageFilters,
    directory = Compose.currentDir(),
    
    onResult = function(files)
      ctx.showOpenDirDialog.value = false
      ctx.showOpenFileDialog.value = false
      ctx.selectedIndex.value = 1
      local images = processFiles(files)
      local dirs = processDirs(files)
      ctx.openFiles.value = images
      ctx.openDirs.value = dirs
    end, 
    
    onCancel = function(done)
      ctx.showOpenFileDialog.value = false
       ctx.showOpenDirDialog.value = false
      ctx.selectedIndex.value = 0
    end
  }
end

function previousIndex(ctx)
  if ctx.openFiles == nil or ctx.selectedIndex == nil then return end
  
  
  local size = #ctx.openFiles.value
  if size == 0 then
    ctx.selectedIndex.value = 0
    return
  end 
  ctx.selectedIndex.value = ctx.selectedIndex.value - 1
  if ctx.selectedIndex.value < 1 then ctx.selectedIndex.value = size end
end

function nextIndex(ctx)
  if ctx.openFiles == nil or ctx.selectedIndex == nil then return end
  
  local size = #ctx.openFiles.value
  if size == 0 then
    ctx.selectedIndex.value = 0
    return
  end 
  ctx.selectedIndex.value = ctx.selectedIndex.value + 1
  if ctx.selectedIndex.value > size then ctx.selectedIndex.value = 1 end
end

function AppMenuBar(ctx)
  
  return MenuBar {
      Menu { 
        text = "File",
        MenuItem { 
          text = "Open Image",
          onClick = function()
            ctx.showOpenFileDialog.value = true
            ctx.showOpenDirDialog.value = false
          end 
        },
        MenuItem { 
          text = "Open Directory",
          onClick = function()
            ctx.showOpenFileDialog.value = false
            ctx.showOpenDirDialog.value = true
          end 
        },
        Separator {}, 
        MenuItem { 
          text = "Exit",
          shortCut = "Ctrl+Q",
          onClick = function()
            ctx.exit.value = true
          end
        },
      },
      Menu { 
        text = "Image",
        MenuItem {
          text = "Next Image",
          onClick = function()
            nextIndex(ctx)
          end
        },
        MenuItem { 
          text = "Previous Image",
          onClick = function()
            previousIndex(ctx)
          end
        }, 
        Separator {},
        MenuItem {
          text = "First Image",
          onClick = function()
            if #ctx.openDirs.value > 0 then ctx.selectedIndex.value = 1 end
          end
        },
        MenuItem {
          text = "Last Image",
          onClick = function()
            if #ctx.openDirs.value > 0 then ctx.selectedIndex.value = #ctx.openDirs.value end
          end
        }, 
        Separator {},
        MenuItem {
          text = ctx.drawDesktop.value == false and "Render On Desktop" or "Render In Window",
          onClick = function()
            ctx.drawDesktop.value = not ctx.drawDesktop.value
          end
        }, 
      },
      Menu { 
        text = "Window",
        MenuItem {
          text = ctx.closeWindow.value and "Show Window" or "Hide Window",
          onClick = function()
            ctx.closeWindow.value = not ctx.closeWindow.value
          end
        }
      },
      Menu { 
        text = "Help",
        MenuItem {
          text = "About",
          onClick = function()
            ctx.about.value = true
          end
        },
        Separator {},
        MenuItem {
          text = "View Git Repo",
          onClick = function()
            love.system.openURL( "https://github.com/hexaredecimal/Lua-compose/" )
          end
        }
      }
    }
end

function ImageViewer(ctx)
      
    if ctx.closeWindow.value then return end
  
    return Window {
      width = 300,
      title = ctx.selectedIndex.value == 0 and "Image Viewer" or ctx.openDirs.value[ctx.selectedIndex.value],

      Row {
        Button { 
          text = "<",
          onClick = function()
            previousIndex(ctx)
          end
        },
        ctx.selectedIndex.value == 0 and Button {
          text = "Pick Image",
          onClick = function()
            ctx.showOpenFileDialog.value = true
          end
        } or
        Text { 
          text ="File: " .. ctx.selectedIndex.value .. "/" .. #ctx.openFiles.value
        },
        Button { 
          text = ">", 
          onClick = function()
            nextIndex(ctx)
          end
        }
      },
      not ctx.drawDesktop.value 
      and Image { paintResource = ctx.selectedIndex.value == 0 and nil or ctx.openFiles.value[ctx.selectedIndex.value] }
      or nil,
      ctx.selectedIndex.value > 0 and ContextMenu {
        MenuItem {
          text = "Next Image",
          onClick = function()
            nextIndex(ctx)
          end
        },
        MenuItem { 
          text = "Previous Image",
          onClick = function()
            previousIndex(ctx)
          end
        }, 
        Separator {},
        MenuItem {
          text = "First Image",
          onClick = function()
            if #ctx.openDirs.value > 0 then ctx.selectedIndex.value = 1 end
          end
        },
        Separator {},
        MenuItem {
          text = "Last Image",
          onClick = function()
            if #ctx.openDirs.value > 0 then ctx.selectedIndex.value = #ctx.openDirs.value end
          end
        }
      } or nil,
      openFile(ctx),
      Text { text = ctx.selectedIndex.value == 0  
        and "No: Images"
        or "Image: " .. ctx.openDirs.value[ctx.selectedIndex.value]
      }
    }
    
end

function ImagesList(ctx) 
  if ctx.selectedIndex.value == 0 then
    return nil
  end 
  
  return Window {
    title = "Images List",
    
    List {
      items = ctx.openDirs.value,
      each = function(item)
        return Text { 
          text = ctx.openDirs.value[ctx.selectedIndex.value] == tostring(item) 
            and "[" .. tostring(item)  .. "]"
            or tostring(item) 
          }
      end,
      
      onSelect = function(index)
        ctx.selectedIndex.value = index
      end
    }
  }
  
end

function love.update(dt)
  
  local ctx = {
    showOpenFileDialog = Remember.by { false }, 
    showOpenDirDialog = Remember.by { false }, 
    openFiles = Remember.by { {} },
    openDirs = Remember.by { {} },
    selectedIndex = Remember.by { 0 },
    closeWindow = Remember.by { false },
    drawDesktop = Remember.by { false },
    exit = Remember.by { false },
    about = Remember.by { false }
  }
  

  App {
    AppMenuBar(ctx),
    ImageViewer(ctx),
    ImagesList(ctx), 
    YesNoDialog { 
      title = "Do you really want to quit?",
      text = "Exit the app?",
      show = ctx.exit.value,
      onYes = function()
        love.event.quit()
      end,
      onNo = function()
        ctx.exit.value = false
      end
    },
    MessageDialog {
      title = "About App",
      text = "ImageViewer\nAn example compose application in lua\n\n(c) " 
      .. ((os.date("%Y") == "2025") and "2025" 
      or 2025 .. " - " .. os.date("%Y")) .. " - Gama Sibusiso.\n",
      show = ctx.about.value,
      onClose = function()
        ctx.about.value = false
      end
    }
  }
  

  
  if ctx.drawDesktop.value and ctx.selectedIndex.value > 0 then 
    Later.draw(function()
      local img = ctx.openFiles.value[ctx.selectedIndex.value]
      local winW, winH = love.graphics.getDimensions()
      local imgW, imgH = img:getWidth(), img:getHeight()

      local x = (winW - imgW) / 2
      local y = (winH - imgH) / 2
      love.graphics.setColor(1,1,1)
      love.graphics.draw(
        img,
        x, 
        y
      )  
      love.graphics.rectangle("line", x, y, imgW, imgH)
    end)    
  end

end

function love.draw()
  Compose.render()
end
