local component = require("component")
local event = require("event")
local s = require("serialization")
local dispenser = require("dispenser")
local modem = component.proxy(component.list("modem")())
local tun = component.proxy(component.list("tunnel")())
dispenser.open(1024)
dispenser.open(1025)
stationradar = {}
ottawaradar = {}
shipradar = {}

function incoming(_, _, remoteAddress, port, _, data)
        if port == 1024 or port == 0 then
            print("got message on port: "..port.." data: "..data)
            if string.find(data, "stationradar") then
                print("saving stationradar as radar")
                data = string.gsub(data, "stationradar", "radar")
                stationradar = s.unserialize(data)
            elseif string.find(data, "ottawaradar") then
                print("saving ottawaradar as radar")
               data = string.gsub(data, "ottawaradar", "radar")
                ottawaradar = s.unserialize(data)
            elseif string.find(data, "shipradar") then
                print("saving shipradar as radar")
               data = string.gsub(data, "shipradar", "radar")
                shipradar = s.unserialize(data)
            end
        elseif port == 1025 or port == 0 then 
            if string.find(data, "request") then
                if string.find(data, "station") then
                print("got request for station variable")
                dispenser.send(remoteAddress, port, s.serialize(stationradar))
                elseif string.find(data, "ottawa") then
                print("got request for ottawa variable")
                dispenser.send(remoteAddress, port, s.serialize(ottawaradar))
                elseif string.find(data, "ship") then
                print("got request for ship variable")
                dispenser.send(remoteAddress, port, s.serialize(shipradar))
                end
            end
        end 
end
event.listen("dispenser", incoming)
while true do
event.pull("modem_message")
os.sleep(0)
end