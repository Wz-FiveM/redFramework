RedFW.Server.Components.Players.items = {}
RedFW.Server.Components.Players.items.list = {}

---registerItem
---@param name string
---@param label string
---@param weight number
---@param useCallback table
function RedFW.Server.Components.Players.items:registerItem(name, label, weight, useCallback)
    RedFW.Server.Components.Players.items.list[name] = {
        name = name,
        label = label,
        weight = weight or 1.0,
        useCallback = useCallback or function() return false end
    }
    local itemClient = {
        name = name,
        label = label,
        weight = weight or 1.0
    }
    RedFW.Shared.Event:triggerClientEvent("registerItem", -1, itemClient)
end

---getItem
---@param name string
function RedFW.Server.Components.Players.items:getItem(name)
    if not RedFW.Server.Components.Players.items:itemExist(name) then
        return
    end
    return RedFW.Server.Components.Players.items.list[name]
end

---getWeight
---@param name string
function RedFW.Server.Components.Players.items:getWeight(name)
    if not RedFW.Server.Components.Players.items:itemExist(name) then
        return
    end
    return RedFW.Server.Components.Players.items.list[name].weight
end

---getAll
function RedFW.Server.Components.Players.items:getAll()
    return RedFW.Server.Components.Players.items.list
end

---itemExist
---@param name string
function RedFW.Server.Components.Players.items:itemExist(name)
    return (RedFW.Server.Components.Players.items.list[name] ~= nil)
end

AddEventHandler("playerConnecting", function()
    local _src <const> = source
    local itemListClient = {}
    for k, v in pairs(RedFW.Server.Components.Players.items.list) do
        itemListClient[k] = {
            name = v.name,
            label = v.label,
            weight = v.weight
        }
    end
    RedFW.Shared.Event:triggerClientEvent("registerItem", _src, itemListClient)
end)