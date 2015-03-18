local component = require("component")
local event = require("event")
local modem = component.modem
local port = 2412
local r = component.proxy(component.list("radar")())
modem.open(port)
modem.broadcast(port, "drone=component.proxy(component.list('drone')())")

local yourName = "PG_Gorzoid"

local drone = {}
drone.x = -2
drone.y = 65
drone.z = -14

local radar = {}
radar.x = -0
radar.y = 64
radar.z = -14

function droneMsg(cmd)
  if not cmd then return end
  modem.broadcast(port, cmd)
end
local function findPlayer()
    playerlist = r.getPlayers()
    for _,players in pairs(playerlist) do
        if players.name == "nightsta69" then
            x = players.x
        playerx = math.floor(x + radar.x)
        y = players.y
        playery = math.floor(y + radar.y)
        z = players.z
        playerz = math.floor(z + radar.z)
            return playerx,playery,playerz
        end
	
    end
end
local function moveDrone(playerx,playery,playerz)
	local drone.x = (playerx - drone.x)
	local drone.y = playery - drone.y
	local drone.z = playerz - drone.z
	local cmd = "drone.move("..drone.x..","..drone.y..","..drone.z..")"
	droneMsg(cmd)
end
while true do
  local playerx,playery,playerz = findPlayer()
  moveDrone(playerx,playery,playerz)
end