local component = require("component")
local tcpnet = require("tcpnet")
local event = require("event")
portkeepalive = 256
handle = tcpnet.new("198.27.109.102")
handle:open(portkeepalive)
 
 
function keepalive()
        handle:send(portkeepalive, "ping")
        print("haven't been pinged in a while, pinging")
        local _, _, port, data = event.pull(10, "tcpnet_message")
            if data == nil then
                print("got nothing, reconnecting")
                handle:close(portkeepalive)
                handle = tcpnet.new("198.27.109.102")
                handle:open(portkeepalive)
                event.listen("tcpnet_message", incoming)
                a = event.timer(30, keepalive)
                return
            elseif port == portkeepalive and data == "pong" then
                print("got keep alive")
                event.listen("tcpnet_message", incoming)
                a = event.timer(30, keepalive)
                return
            end    
end       
   
function incoming(port, data)
    if data == "ping" and port == portkeepalive then
        print("pinged on keepalive port")
        handle:send(portkeepalive, "pong")
        event.cancel(a)
        a = event.timer(30, keepalive)
    end
end

a = event.timer(30, keepalive)

while true do
local _, _, port, data = event.pull("tcpnet_message")
incoming(port, data)
os.sleep(0)
end