local component = require("component")
local event = require("event")
local fs = require("filesystem")
local keyboard = require("keyboard")
local shell = require("shell")
local term = require("term")
local text = require("text")
local unicode = require("unicode")
local sides = require("sides")
local colors=require("colors")
local g = component.proxy(component.list("glasses")())
running = true
local a = 1
local component = require("component")
local r = component.proxy(component.list("radar")())
local playerlist = r.getPlayers()
local radar = {}
radar.x = 0
radar.y = 64
radar.z = -15
local gterm = {}
gtermx = 5
gtermy = 64
gtermz = -16
local playerx = 0
local playery = 0
local playerz = 0
local idlist = {}
local textlist = {}
local pending ={}
g.removeAll()
 
local function printXY(row, col, ...)
  term.setCursor(col, row)
  print(...)
end
 
local function gotoXY(row, col)
  term.setCursor(col,row)
end
 
function in_table ( Xneedle, Xhaystack )
    result = true
    for Xkey,Xvalue in pairs(Xhaystack) do
        if (Xvalue.name==Xneedle) then
          result = true
          break
        else result = false
        end
    end
    return result
end
 
term.clear()
term.setCursorBlink(false)
while running do
a = 3
playerlist = r.getPlayers()
printXY(1, 1, "Name:          X:          Y:          Z:")  --16, 28, 40
printXY(2, 1, "=============================================")
  for _,players in pairs(playerlist) do
      if pending[players.name] == nil then
         pending[players.name] = players.name
      end
        term.setCursor(1, a)
        term.clearLine()
      if idlist[players.name] == nil then
        d = g.addCube3D()
        t = g.addFloatingText()
        idlist[players.name] = d
        textlist[players.name] = t
      end
        printXY(a, 1, players.name)
        x = players.x
        playerx = math.floor(x + radar.x)
        printXY(a, 16, playerx)
        y = players.y
        playery = math.floor(y + radar.y)
        printXY(a, 28, playery)
        z = players.z
        playerz = math.floor(z + radar.z)
        printXY(a, 40, playerz)
        if players.name ~= "nightsta69" then
          c = idlist[players.name]
          text = textlist[players.name]
          text.setColor(0, 1, 0)
          c.setColor(0, 1, 0)
          modx = math.floor(playerx - gtermx)
          mody = math.floor(playery - gtermy+1)
          modz = math.floor(playerz - gtermz)
          text.setText(players.name)
          text.set3DPos(modx, mody+3, modz)
          c.set3DPos(modx, mody+.5, modz)
          printXY(a, 45, "On Target")
        end
        a = a + 1
    end
    playerlist = r.getPlayers()
 local b = 10
    for key,value in pairs(pending) do
            if (in_table(value,playerlist))==false then
                x = idlist[value]
                tl = textlist[value]
                g.removeObject(x.getID())
                g.removeObject(tl.getID())
                idlist[value] = nil
                textlist[value] = nil
            end
    end
pending = {}
term.setCursor(1, a)
term.clearLine()
os.sleep(0)
end