local component = require("component")
local event = require("event")
local s = require("serialization")
local term = require("term")
local tun = component.proxy(component.list("tunnel")())
local br = component.proxy(component.list("br_reactor")())
local pm = component.proxy(component.list("power_monitor")())
local reactorinfo = {}
local isactive = 0
local running = true
term.clear()
print("reactor control relay initiating...")
print("gathering information about the connected reactor.")
print("ready to transmit data.")
while running do
    local _, _, from, port, _, message = event.pull("modem_message")
    if message == "reactorinfo" then
        print(message .. from .. " on port " .. port)
        print("fetching and serializing reactorinfo and sending to remote host.")
        reactorinfo = {["maxcapacity"] = pm.getMaxPowerInCapBanks(), ["curcap"] = pm.getPowerInCapBanks(), ["avgreceived"]= pm.getAverageEnergyReceived(), ["avgsent"] = pm.getAverageEnergySent(), ["ppt"] = pm.getPowerPerTick(), ["isactive"] = br.getActive(), ["casetemp"] = br.getCasingTemperature(), ["energytick"] = br.getEnergyProducedLastTick(), ["fuelamt"] = br.getFuelAmount(), ["fuelmax"] = br.getFuelAmountMax(), ["fuelconsumed"] = br.getFuelConsumedLastTick()}
        tun.send(s.serialize(reactorinfo))
        print("sent")
        os.sleep(0)
    elseif message == "deactivate" then
            if br.getActive() == true then
                br.setActive(false)
            end
    elseif message == "activate" then
            if br.getActive() == false then
                br.setActive(true)
            end  
    end
end