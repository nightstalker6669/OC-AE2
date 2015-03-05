local component = require("component")
local ae = component.proxy(component.list("me_controller")())
    local toCraft = {"Oak Wood Planks", 1}
    local crafting = {}
    local craftables = ae.getCraftables()
  local networkItems = ae.getItemsInNetwork()
  if craftables == nil then return end
    for _,label in ipairs(toCraft) do
        print(label)
        for i,j in ipairs(craftables) do
                if (j.getItemStack().label == label) then
                    print("yes it matches, next")
                 
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