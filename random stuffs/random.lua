local require("tcpnet")
local component=require("component")
handle=tcpnet.new("198.27.109.101")
handle:open(1024)
running = true
while running do
a = handle:receive()
for k, v in pairs(a) do
print(k,v)
end
end




local component = require("component")
local event = require("event")
tun = component.proxy(component.list("internet")())
local tcpnet = require("tcpnet")
local handle = tcpnet.new("198.27.109.101")
handle:open(1024)
while true do
-- Wait for a message from another network card.
local _, port, data = event.pull("tcpnet_message")
print("Got a message on port " .. port .. ": " ..data)
os.sleep(0)
end

local component = require("component")
local event = require("event")
tun = component.proxy(component.list("internet")())
local tcpnet = require("tcpnet")
local handle = tcpnet.new("198.27.109.101")
handle:open(1024)
while true do
a = io.read()
print("enter your message:"..a)
    handle:send(1024, a)
end

local component = require("component")
local event = require("event")
local m = component.modem -- get primary modem component
m.open(1024)
print(m.isOpen(1024)) -- true
-- Send some message.
m.broadcast(321, "this is a test")
-- Wait for a message from another network card.
while true do local _, event, ch, data, remoteaddr, port = event.pull("tcp") print(event, ch, data, remoteaddr, port) end

while true do local _, origin, port, data = event.pull("datagram") print(origin, port, data) network.udp.send(origin, port, "got it") end

network.ip.bind("192.168.1.3")
network.tcp.listen(1024)




"tcp", "message", ch, data, remoteaddr, port
    event on remote side





