local component = require("component")
local event = require("event")
local s = require("serialization")
local term = require("term")
local network = require("network")
local br = component.proxy(component.list("br_reactor")())
local pm = component.proxy(component.list("power_monitor")())
local reactorinfo = {}
local isactive = 0
local percentpowerlow = 0
local percentpowerhigh = 0
local charging = false
local running = true
term.clear()
network.ip.bind("192.168.1.10")
network.udp.open(1024)
print("reactor control relay initiating...")
print("gathering information about the connected reactor.")
print("ready to transmit data.")
while running do
        reactorinfo = {["name"] = "reactorinfo", ["maxcapacity"] = pm.getMaxPowerInCapBanks(), ["curcap"] = pm.getPowerInCapBanks(), ["avgreceived"]= pm.getAverageEnergyReceived(), ["avgsent"] = pm.getAverageEnergySent(), ["ppt"] = pm.getPowerPerTick(), ["isactive"] = br.getActive(), ["casetemp"] = br.getCasingTemperature(), ["energytick"] = br.getEnergyProducedLastTick(), ["fuelamt"] = br.getFuelAmount(), ["fuelmax"] = br.getFuelAmountMax(), ["fuelconsumed"] = br.getFuelConsumedLastTick()}
        print("sending")
        network.udp.send("192.168.1.1", 1024, s.serialize(reactorinfo))
        print("sent")
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
