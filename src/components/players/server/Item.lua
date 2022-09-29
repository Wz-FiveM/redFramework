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

function RedFW.Server.Components.Players.items:register(data)
    if data.name == nil then return end 
    if data.label == nil then return end
    if data.weight == nil then return end
    RedFW.Server.Components.Players.items(data)
end

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
                print("^1Inventory is full^0")
                return false
            end
        end
    end
end

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
                    print("^1You don't have enough items^0")
                    return false
                end
            else
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