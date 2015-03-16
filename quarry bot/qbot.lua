local robot = require("robot")
local sides = require("sides")
local nav = require("nav")
local qb = nav:new()
local component = require("component")
local tun = component.proxy(component.list("tunnel")())
local rs = component.redstone
local inv = component.inventory_controller
local term = require("term")
local s = require("serialization")
term.clear()
 qbottable = {}
 qbottable.status = ""
 qbottable.x = 0
 qbottable.y = 0
 qbottable.z = 0
 qbottable.currentaction = ""

    qbotco = coroutine.create(function ()
        while true do
            tun.send(s.serialize(qbottable))
            coroutine.yield()
        end
    end)
        
 local i = 1
local x = 0
 
function sort(arg1)
    for i = 1, 16 do
        a = inv.getStackInInternalSlot(i)
    if a ~= nil then
        if a.name == arg1 then
        robot.select(i)
        robot.placeDown()
        end
    end
    end
end
 

function detectD()
    if robot.detectDown() == true then
        robot.swingDown()
    end
end
 
function detectF()
    if robot.detect() == true then
        robot.swing()
    end
end
 
function detectU()
    if robot.detectUp() == true then
        robot.swing()
    end
end
 

function setup()
    qbottable.status = "Setting up"
-- quarry setup
    detectD()
    qbottable.currentaction = "placing ender quarry"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:enderQuarry")
    robot.turnLeft()
    detectF()
    robot.forward()
    detectD()
    qbottable.currentaction = "placing ender quarry upgrade"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:enderQuarryUpgrade")
    robot.turnAround()
    robot.forward()
    robot.turnLeft()
    detectF()
    robot.forward()
-- first marker
    detectD()
    robot.down()
    detectD()
    sort("chisel:cobblestone")
    robot.up()
    qbottable.currentaction = "placing first marker"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:endMarker")
-- second marker
    qbottable.currentaction = "moving to second marker"
    coroutine.resume(qbotco)
    qb:go({x + 16,0,0})
    detectD()
    robot.down()
    detectD()
    sort("chisel:cobblestone")
    robot.up()
    qbottable.currentaction = "placing second marker"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:endMarker")
-- third marker
    qbottable.currentaction = "moving to third marker"
    coroutine.resume(qbotco)
    qb:go({x + 16,16,0})
    detectD()
    robot.down()
    detectD()
    sort("chisel:cobblestone")
    robot.up()
    qbottable.currentaction = "placing third marker"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:endMarker")
-- fourth marker
    qbottable.currentaction = "moving to fourth marker"
    coroutine.resume(qbotco)
    qb:go({x,16,0})
    detectD()
    robot.down()
    detectD()
    sort("chisel:cobblestone")
    robot.up()
    qbottable.currentaction = "placing fourth marker"
    coroutine.resume(qbotco)
    sort("ExtraUtilities:endMarker")
-- back to quarry and activate
    qbottable.currentaction = "moving to activate quarry"
    coroutine.resume(qbotco)
    qb:go({x,0,0})
    robot.turnLeft()
    robot.forward()
    qbottable.currentaction = "activating quarry"
    coroutine.resume(qbotco)
    robot.useDown()
-- place tess and chargers
    detectU()
    robot.up()
    qbottable.currentaction = "placing tesseract"
    coroutine.resume(qbotco)
    sort("ThermalExpansion:Tesseract")
    detectF()
    robot.forward()
    detectD()
    qbottable.currentaction = "placing power conduit"
    coroutine.resume(qbotco)
    sort("EnderIO:itemPowerConduit")
    detectF()
    robot.forward()
    detectD()
    robot.placeDown()
    robot.turnRight()
    detectF()
    robot.forward()
    detectD()
    qbottable.currentaction = "placing wireless charger"
    coroutine.resume(qbotco)
    sort("EnderIO:blockWirelessCharger")
    robot.turnRight()
    detectF()
    robot.forward()
    detectD()
    qbottable.currentaction = "placing docking station"
    coroutine.resume(qbotco)
    sort("OpenComputers:charger")
-- start charger and sleep
    qbottable.status = "Charging"
    qbottable.currentaction = "waiting for quarry to complete"
    coroutine.resume(qbotco)
    rs.setOutput(sides.down, 15)
    os.sleep(300)
    rs.setOutput(sides.down, 0)
  return
end

function teardown()
    qbottable.status = "tearing down"
    coroutine.resume(qbotco)
-- quarry teardown
    robot.forward()
    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.down()
    robot.turnAround()
-- first marker
    qbottable.currentaction = "removing first marker"
    coroutine.resume(qbotco)
    detectD()
    robot.down()
    detectD()
    robot.up()
-- second marker
    qbottable.currentaction = "moving to second marker"
    coroutine.resume(qbotco)
    qb:go({x + 16,0,0})
    qbottable.currentaction = "removing second marker"
    coroutine.resume(qbotco)
    detectD()
    robot.down()
    detectD()
    robot.up()
-- third marker
    qbottable.currentaction = "moving to third marker"
    coroutine.resume(qbotco)
    qb:go({x + 16,16,0})
    qbottable.currentaction = "removing third marker"
    coroutine.resume(qbotco)
    detectD()
    robot.down()
    detectD()
    robot.up()
-- fourth marker
    qbottable.currentaction = "moving to fourth marker"
    coroutine.resume(qbotco)
    qb:go({x,16,0})   
    qbottable.currentaction = "removing fourth marker"
    coroutine.resume(qbotco)
    detectD()
    robot.down()
    detectD()
    robot.up()
-- back to quarry remove stuff
    qbottable.currentaction = "moving to remove everything else"
    coroutine.resume(qbotco)
    qb:go({x,0,0})
    robot.turnLeft()
    robot.up()
    robot.forward()
    qbottable.currentaction = "removing tesseract"
    coroutine.resume(qbotco)
    detectD()
    robot.forward()
    qbottable.currentaction = "removing power conduits"
    coroutine.resume(qbotco)
    detectD()
    robot.forward()
    detectD()
    robot.turnRight()
    robot.forward()
    qbottable.currentaction = "removing wireless charger"
    coroutine.resume(qbotco)
    detectD()
    robot.turnRight()
    robot.forward()
    qbottable.currentaction = "removing docking station"
    coroutine.resume(qbotco)
    detectD()
    robot.forward()
    robot.down()
    qbottable.currentaction = "removing ender quarry speed upgrade"
    coroutine.resume(qbotco)
    detectD()
    robot.turnRight()
    robot.forward()
    qbottable.currentaction = "removing ender quarry"
    coroutine.resume(qbotco)
    detectD()
    robot.turnLeft()
    robot.forward()
    os.sleep(1)
end

function newSpot()
qbottable.status = "moving to new spot"
x = x + 16
qbottable.x = math.floor(qbottable.x + x)
coroutine.resume(qbotco)
robot.turnLeft()
qb:go({x,0,0})
end
 
while true do
setup()
teardown()
newSpot()
end