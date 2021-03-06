local component = require("component")
local ae = component.proxy(component.list("me_controller")())
local term = require("term")
    local toCraft = {}
    local crafting = {}
    local temptable = {}
    local craftables = ae.getCraftables()
  local networkItems = ae.getItemsInNetwork()
  
  
function craftlist()
  if craftables == nil then 
    return 
  end
    for xkey, xvalue in ipairs(craftables) do
        table.insert(temptable, xvalue.getItemStack().label)
    end
    return temptable
  end

function craftmanager()
    b = listBox:getSelected()
    table.insert(toCraft, temptable[b])
    for _,label in ipairs(toCraft) do
        for i,j in ipairs(craftables) do                 
            crafting[label] = j.request(j.getItemStack().size)
                if crafting[label] == nil or crafting[label].isCanceled() == true then
                    print("fail "..j.getItemStack().size .. " x " .. label)
                    crafting[label] = nil
                else
                    print("success "..j.getItemStack().size .. " x " .. label)
                end
                   
          break;
        end
   
    end
end