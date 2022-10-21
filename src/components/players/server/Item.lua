RedFW.Server.Components.Players.items = {}
RedFW.Server.Components.Players.items.list = {}

setmetatable(RedFW.Server.Components.Players.items, {
    __call = function(_, data)
        local self = setmetatable({}, RedFW.Server.Components.Players.items)
        self.data = data
        self.getLabel = function()
            return self.data.label
        end
        self.getWeight = function()
            return self.data.weight
        end
        RedFW.Server.Components.Players.items.list[self.data.name] = self
        return self
    end
})

---register
---@param data table
---@return void
---@public
function RedFW.Server.Components.Players.items:register(data)
    if data.name == nil then return end 
    if data.label == nil then return end
    if data.weight == nil then return end
    RedFW.Server.Components.Players.items(data)
end

---get
---@param name string
---@return table
---@public
function RedFW.Server.Components.Players.items:get(name)
    if RedFW.Server.Components.Players.items.list[name] == nil then print("^1Item : ("..name..") does not exist^0") return end
    return RedFW.Server.Components.Players.items.list[name]
end

function RedFW.Server.Components.Players.items:getAll()
    return RedFW.Server.Components.Players.items.list
end

RedFW.Server.Components.Players.items:register({
    name = "water",
    label = "Water",
    weight = 0.5
})

RedFW.Server.Components.Players.items:register({
    name = "bread",
    label = "Bread",
    weight = 0.5
})

---addItem
---@param serverId number
---@param name string
---@param count number
---@return boolean
---@public
function RedFW.Server.Components.Players.items:addItem(serverId, name, count)
    local item = RedFW.Server.Components.Players.items:get(name)
    if item then
        local inventory = RedFW.Server.Components.Players.inventory:get(serverId)
        if inventory then
            if inventory.getWeight() + (item.getWeight() * count) <= RedFW.Default.Inventory.weight then
                if inventory.data[name] == nil then
                    inventory.data[name] = {
                        label = item.getLabel(),
                        weight = item.getWeight(),
                        count = count
                    }
                else
                    inventory.data[name].count = inventory.data[name].count + count
                end
                inventory:save()
                RedFW.Shared.Event:triggerClientEvent('receiveInventory', serverId, inventory, inventory.getWeight())
                return true
            else
                RedFW.Shared.Event:triggerClientEvent('receiveNotification', serverId, "~r~You can't carry more")
                print("^1The player cannot receive this amount as it will exceed the maximum item limit on being.^0")
                return false
            end
        end
    end
end

---removeItem
---@param serverId number
---@param name string
---@param count number
---@return boolean
---@public
function RedFW.Server.Components.Players.items:removeItem(serverId, name, count)
    local item = RedFW.Server.Components.Players.items:get(name)
    if item then
        local inventory = RedFW.Server.Components.Players.inventory:get(serverId)
        if inventory then
            if inventory.data[name] ~= nil then
                if inventory.data[name].count - count >= 0 then
                    inventory.data[name].count = inventory.data[name].count - count
                    inventory:save()
                    RedFW.Shared.Event:triggerClientEvent('receiveInventory', serverId, inventory, inventory.getWeight())
                    return true
                else
                    RedFW.Shared.Event:triggerClientEvent('receiveNotification', serverId, "~r~You don't have enough")
                    print("^1You don't have enough items^0")
                    return false
                end
            else
                RedFW.Shared.Event:triggerClientEvent('receiveNotification', serverId, "~r~You don't have this item")
                print("^1You don't have this item^0")
                return false
            end
        end
    end
end

RegisterCommand('addItem', function(source, args)
    local _src = tonumber(args[1])
    local item = args[2]
    local count = tonumber(args[3])
    RedFW.Server.Components.Players.items:addItem(_src, item, count)
end)

RedFW.Shared.Event:registerEvent("loadItem", function()
    RedFW.Shared.Event:triggerClientEvent("loadItem", source, RedFW.Server.Components.Players.items:getAll())
end)