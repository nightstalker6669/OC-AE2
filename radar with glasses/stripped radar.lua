local component = require("component")
local event = require("event")
local term = require("term")
local r = component.proxy(component.list("radar")())
local tun = component.proxy(component.list("tunnel")())
s = require("serialization")
running = true
local playerlist = r.getPlayers()
local radar = {}
radar.name = "spacestation"
radar.x = 0
radar.y = 64
radar.z = -15
 
term.clear()
term.setCursorBlink(false)
while running do
    local stationradar = r.getPlayers()
    table.insert(stationradar,1, radar)
        tun.send(s.serialize(stationradar))
os.sleep(0)
    end