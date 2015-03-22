local component = require("component")
local event = require("event")
local keyboard = require("keyboard")
local s = require("serialization")
local term = require("term")
local tun = component.proxy(component.list("tunnel")())
local running = true
local gpu = component.gpu
local network = require("network")
local reactorinfo = {}
gpu.setResolution(45, 16)
term.clear()
network.ip.bind("192.168.1.11")
network.udp.open(1025)
network.udp.send("192.168.1.1",1025, "request")
local _, origin, port, data = event.pull("datagram")
    reactorinfo = s.unserialize(data)
charging = reactorinfo.isactive
 
local function printXY(row, col, ...)
  term.setCursor(col, row)
  term.clearLine()
  print(...)
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
 
term.clear()
while running do
printXY(1, 1, "Reactor Information")
printXY(2, 1, "=========================")
 
     if reactorinfo.isactive == true then
        printXY(3, 1,"Reactor: Online")
     else
        printXY(3, 1,"Reactor: Offline")
     end
printXY(4, 1, "Case Temperature: "..round(reactorinfo.casetemp, 2).." degrees C")
printXY(5, 1, "Current Fuel: " ..reactorinfo.fuelamt.." / "..reactorinfo.fuelmax)
printXY(6, 1, "Fuel Consumed: " ..round(reactorinfo.fuelconsumed, 3).." mb/Tick")
printXY(7, 1, "RF/T Produced: " ..round(reactorinfo.energytick, 2))
printXY(8, 1, "")
printXY(9, 1, "")
printXY(10, 1, "Capacitor Information")
printXY(11, 1, "=========================")
    if reactorinfo.isactive == true then
        printXY(12, 1, "Charge State: Charging")
    else
        printXY(12, 1, "Charge State: Discharging")
    end
printXY(13, 1, "Current Capacitor: " ..reactorinfo.curcap.." / "..reactorinfo.maxcapacity)
printXY(14, 1, "Average Input: "..round(reactorinfo.avgreceived, 2).." RF/Tick")
printXY(15, 1, "Average Output: "..round(reactorinfo.avgsent, 2).." RF/Tick")
 
network.tcp.send(1, "request")
network.udp.send("192.168.1.1",1025, "request")
local _, origin, port, data = event.pull("datagram")
        reactorinfo = s.unserialize(data)
end
term.clear()