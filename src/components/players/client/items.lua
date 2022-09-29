RedFW.Client.Components.Player.items = { list = { } }

---getItem
---@param name string
function RedFW.Client.Components.Player.items:getItem(name)
    if not RedFW.Client.Components.Player.items:itemExist(name) then
        return
    end
    return RedFW.Client.Components.Player.items.list[name]
end

---getAll
function RedFW.Client.Components.Player.items:getAll()
    return RedFW.Client.Components.Player.items.list
end

---itemExist
---@param name string
function RedFW.Client.Components.Player.items:itemExist(name)
    return (RedFW.Client.Components.Player.items.list[name] ~= nil)
end


RedFW.Shared.Event:registerEvent("loadItem", function(itemList)
    RedFW.Client.Components.Player.items.list = itemList
end)

RedFW.Shared.Event:registerEvent("registerItem", function(item)
    RedFW.Client.Components.Player.items.list[item.name] = item
end)
