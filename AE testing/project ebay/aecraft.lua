local component = require("component")
local ae = component.proxy(component.list("me_controller")())
local term = require("term")
    local toCraft = {}
    local crafting = {}
    local craftables = ae.getCraftables()
  local networkItems = ae.getItemsInNetwork()
    local temptable = {}
 
 
function craftlist()
    local temptable = {}
    for xkey, xvalue in ipairs(craftables) do
        table.insert(temptable, xvalue.getItemStack().label)
    end
    return temptable
  end
 
function craftmanager(arg1)
      label = arg1
        for i,j in ipairs(craftables) do
           if (j.getItemStack().label == label) then                
            crafting[label] = j.request(j.getItemStack().size)
                if crafting[label] == nil or crafting[label].isCanceled() == true then
                    crafting[label] = nil
                else
                    crafting = {}
                    label = nil
                end
           end        
        end
    end