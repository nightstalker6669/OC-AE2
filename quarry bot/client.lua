local component = require("component")
local event = require("event")
local keyboard = require("keyboard")
local s = require("serialization")
local term = require("term")
local tun = component.proxy(component.list("tunnel")())
local running = true
local gpu = component.gpu
qbottable = {}
gpu.setResolution(45, 16)


local _, _, from, port, _, message = event.pull("modem_message")
        if string.find(message, "status") ~= nil then
            qbottable = s.unserialize(message)
        end
      
local function printXY(row, col, ...)
  term.setCursor(col, row)
  term.clearLine()
  print(...)
end
term.clear()
while running do
printXY(1, 1, "Quarry Bot Information")
printXY(2, 1, "=========================")
printXY(3, 1, "Current Status: "..qbottable.status)
printXY(4, 1, "X: "..qbottable.x.." Y: "..qbottable.y.." Z: "..qbottable.z)
printXY(5, 1, "currently: "..qbottable.currentaction)
printXY(6, 1, "")

    local _, _, from, port, _, message = event.pull("modem_message")
        if string.find(message, "status") ~= nil then
            qbottable = s.unserialize(message)
        end

end