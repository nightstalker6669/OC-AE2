API = require("buttonAPI")
local component = require("component")
local event = require("event")
local computer = require("computer")
local term = require("term")
local gpu = component.gpu
local rsone = component.proxy("464dd52d-e4c7-4e61-a932-df62418bf558")
local rstwo = component.proxy("2778258c-d016-499a-8eaa-a4ed515c2a45")
local colors = require("colors")
local sides = require("sides")
local running = true
gpu.setResolution(20, 35)
function API.fillTable()
 API.setTable("Skeletons", skele, 5,15,3,5)
 API.setTable("Zombies", zomb, 5,15,7,9)
 API.setTable("Endermen", ender, 5,15,11,13)
 API.setTable("Creepers", creep, 5,15,15,17)
 API.setTable("Spiders", spid, 5,15,19,21)
 API.setTable("Ghasts", ghas, 5,15,23,25)
 API.setTable("Blaze", bla, 5,15,27,29)
 API.setTable("Blizz", bli, 5,15,31,33)
 API.screen()
end
 
function skele()
 API.toggleButton("Skeletons")
 if buttonStatus == true then
  rsone.setOutput(sides.posx, 15)
 else
  rsone.setOutput(sides.posx, 0)
 end
end
 
function zomb()
 API.toggleButton("Zombies")
 if buttonStatus == true then
  rsone.setOutput(sides.negx, 15)
 else
  rsone.setOutput(sides.negx, 0)
 end
end
 
function ender()
 API.toggleButton("Endermen")
 if buttonStatus == true then
  rsone.setOutput(sides.posz, 15)
 else
  rsone.setOutput(sides.posz, 0)
 end
end
 
function creep()
 API.toggleButton("Creepers")
 if buttonStatus == true then
  rsone.setOutput(sides.negz, 15)
 else
  rsone.setOutput(sides.negz, 0)
 end
end
 
function spid()
 API.toggleButton("Spiders")
 if buttonStatus == true then
  rstwo.setOutput(sides.posx, 15)
 else
  rsone.setOutput(sides.posx, 0)
 end
end
 
function ghas()
 API.toggleButton("Ghasts")
 if buttonStatus == true then
  rstwo.setOutput(sides.posz, 15)
 else
  rstwo.setOutput(sides.posz, 0)
 end
end
 
function bla()
 API.toggleButton("Blaze")
 if buttonStatus == true then
  rstwo.setOutput(sides.negx, 15)
 else
  rstwo.setOutput(sides.negx, 0)
 end
end
 
function bli()
 API.toggleButton("Blizz")
 if buttonStatus == true then
  rstwo.setOutput(sides.negz, 15)
 else
  rstwo.setOutput(sides.negz, 0)
 end
end
 
function getClick()
 local _, _, x, y = event.pull(1,touch)
 if x == nil or y == nil then
  local h, w = gpu.getResolution()
  gpu.set(h, w, ".")
  gpu.set(h, w, " ")
 else
  API.checkxy(x,y)
 end
end
 
term.setCursorBlink(false)
API.clear()
API.fillTable()
 
while true do
 getClick()
end