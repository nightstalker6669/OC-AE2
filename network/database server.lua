local component = require("component")
local event = require("event")
local s = require("serialization")
local network = require("network")
network.ip.bind("192.168.1.1")
network.udp.open(1024)
network.udp.open(1025)
reactorinfo = {}


function incoming(origin, port, data)
        if port == 1024 then
            reactorinfo = s.unserialize(data)
        elseif port == 1025 and data == "request" then
            network.udp.send(origin, port, s.serialize(reactorinfo))
        end 
end
event.listen("datagram", incoming)
while true do
event.pull()
os.sleep(0)
end