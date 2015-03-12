local component = require("component")
local sides = require("sides")
local term = require("term")
local rsone = component.proxy(464dd52d-e4c7-4e61-a932-df62418bf558)
local rstwo = component.proxy(2778258c-d016-499a-8eaa-a4ed515c2a45)
running = true
while running do
term.clear()
print("1) freq 1")
print("2) freq 2")
print("3) freq 3")
print("4) freq 4")

request = io.read()

if request == 1 then 
  if rsone.getOutput(sides.east) > 0 then
        rsone.setOutput(sides.east, 0)
  else
       rsone.setOutput(sides.east, 15)
  end
  if request == 2 then 
  if rstwo.getOutput(sides.east) > 0 then
        rstwo.setOutput(sides.east, 0)
  else
       rstwo.setOutput(sides.east, 15)
  end


end