local component = require("component")
local event = require("event")
local keyboard = require("keyboard")
local s = require("serialization")
local term = require("term")
local tcpnet = require("tcpnet")
local tun = component.proxy(component.list("tunnel")())
local running = true
local gpu = component.gpu
local reactorinfo = {}
portopen = 1024
portkeepalive = 255
gpu.setResolution(45, 16)
handle = tcpnet.new("198.27.109.102")
handle:open(portopen)
term.clear()
handle:send(portopen, "request")
local _, _, port, data = event.pull("tcpnet_message")
    if port == portopen then
       reactorinfo = s.unserialize(data)
    end
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
 
 
 function keepalive()
        event.ignore("tcpnet_message", receiveinformation)
        handle:send(portkeepalive, "ping")
        print("haven't been pinged in a while, pinging")
        local _, _, port, data = event.pull(10, "tcpnet_message")
            if data == nil then
                print("got nothing, reconnecting")
                handle:close(portopen)
                handle:close(portkeepalive)
                handle = tcpnet.new("198.27.109.102")
                handle:open(portopen)
                handle:open(portkeepalive)
                a = event.timer(30, keepalive)
                event.listen("tcpnet_message", receiveinformation)
                return
            elseif port == portkeepalive and data == "pong" then
                print("got keep alive")
                a = event.timer(30, keepalive)
                event.listen("tcpnet_message", receiveinformation)
                return
            end    
end        
 
 
function receiveinformation(_, _, port, data)
    if port == portopen and string.find(data, "reactorinfo") then
        reactorinfo = s.unserialize(data)
        event.cancel(a)
        a = event.timer(30, keepalive)
    end
end
 
 
 
a = event.timer(30, keepalive)
event.listen("tcpnet_message", receiveinformation)
 
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
 
handle:send(1024, "request")
os.sleep(.5)
end
term.clear()