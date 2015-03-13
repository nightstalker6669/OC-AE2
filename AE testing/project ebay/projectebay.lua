package.loaded.gml=nil
package.loaded.gfxbuffer=nil
require("aecraft")
gml=require("gml")
local component=require("component")
local sides=require("sides")
local term = require("term")
local a = {"one","two","three"}
term.clear()
 
local gui=gml.create("center","center",80,45)
 
local label=gui:addLabel("center",2,13,"Hello, World!")
 
local textField=gui:addTextField("center",4,18)
local button2=gui:addButton(-4,6,10,3,"Close",gui.close)
 
 
function craft()
  a = listBox:getSelected()
  craftmanager(a)
  a = nil
end
listBox= gui:addListBox("center", 10, 50, 30, craftlist())
local button1=gui:addButton(4,6,10,3,"Test",craft)
gui:run()