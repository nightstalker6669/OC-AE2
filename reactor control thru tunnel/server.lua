local component = require("component")
local event = require("event")
local s = require("serialization")
local term = require("term")
local tun = component.proxy(component.list("tunnel")())
local br = component.proxy(component.list("br_reactor")())
local pm = component.proxy(component.list("power_monitor")())
local reactorinfo = {}
local isactive = 0
local percentpowerlow = 0
local percentpowerhigh = 0
local charging = false
local running = true
term.clear()
print("reactor control relay initiating...")
print("gathering information about the connected reactor.")
print("ready to transmit data.")
while running do
    local _, _, from, port, _, message = event.pull("modem_message")
    if message == "reactorinfo" then
        reactorinfo = {["maxcapacity"] = pm.getMaxPowerInCapBanks(), ["curcap"] = pm.getPowerInCapBanks(), ["avgreceived"]= pm.getAverageEnergyReceived(), ["avgsent"] = pm.getAverageEnergySent(), ["ppt"] = pm.getPowerPerTick(), ["isactive"] = br.getActive(), ["casetemp"] = br.getCasingTemperature(), ["energytick"] = br.getEnergyProducedLastTick(), ["fuelamt"] = br.getFuelAmount(), ["fuelmax"] = br.getFuelAmountMax(), ["fuelconsumed"] = br.getFuelConsumedLastTick()}
        tun.send(s.serialize(reactorinfo))
    end
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