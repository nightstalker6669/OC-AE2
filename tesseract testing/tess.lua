local component = require("component")
local term = require("term")
tess = component.proxy(component.list("tile_thermalexpansion_ender_tesseract_name")())
term.clear()

channelname = tess.getChannelString()
for _, name in ipairs(channelname) do
   print("channel name: ".. name)
end

print("frequency: ".. tess.getFrequency) 
