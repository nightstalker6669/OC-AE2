local component = require("component")
local event = require("event")
local s = require("serialization")
local term = require("term")
local network = require("network")
local br = component.proxy(component.list("br_reactor")())
local pm = component.proxy(component.list("power_monitor")())
tcpnet = require("tcpnet")
local reactorinfo = {}
local isactive = 0
local percentpowerlow = 0
local percentpowerhigh = 0
local charging = false
local running = true
portkeepalive = 255
portopen = 1024
handle = tcpnet.new("198.27.109.102")
handle:open(portopen)
handle:open(portkeepalive)
term.clear()
print("reactor control relay initiating...")
print("gathering information about the connected reactor.")
print("ready to transmit data.")
 
function reactorinformation()
    reactorinfo = {["name"] = "reactorinfo", ["maxcapacity"] = pm.getMaxPowerInCapBanks(), ["curcap"] = pm.getPowerInCapBanks(), ["avgreceived"]= pm.getAverageEnergyReceived(), ["avgsent"] = pm.getAverageEnergySent(), ["ppt"] = pm.getPowerPerTick(), ["isactive"] = br.getActive(), ["casetemp"] = br.getCasingTemperature(), ["energytick"] = br.getEnergyProducedLastTick(), ["fuelamt"] = br.getFuelAmount(), ["fuelmax"] = br.getFuelAmountMax(), ["fuelconsumed"] = br.getFuelConsumedLastTick()}
end
 
function capcontrol()
charging = reactorinfo.isactive
percentpowerlow = math.floor(.1*reactorinfo.maxcapacity)
percentpowerhigh = math.floor(.99*reactorinfo.maxcapacity)
     if reactorinfo.curcap < percentpowerlow and charging == false then
        if br.getActive() == false then
           br.setActive(true)
           charging = true
        end
     elseif reactorinfo.curcap > percentpowerhigh and charging == true then
            if br.getActive() == true then
               br.setActive(false)
               charging = false
            end
     end  
 
end
 
function keepalive()
    event.ignore("tcpnet_message", sendinformation)
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
                event.listen("tcpnet_message", sendinformation)
                return
            elseif port == portkeepalive and data == "pong" then
                print("got keep alive")
                a = event.timer(30, keepalive)
                event.listen("tcpnet_message", sendinformation)
                return
            end    
end        
 
function sendinformation(_, _, port, data)
    if port == portopen and data == "request" then
        handle:send(portopen, s.serialize(reactorinfo))
        event.cancel(a)
        a = event.timer(30, keepalive)
        return
    end
end
 
a = event.timer(30, keepalive)
event.listen("tcpnet_message", sendinformation)

while running do
    reactorinformation()
    capcontrol()        
    os.sleep(0)
end