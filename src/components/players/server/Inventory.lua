RedFW.Server.Components.Players.inventory = {}
RedFW.Server.Components.Players.inventory.list = {}
RedFW.Server.Components.Players.inventory.__index = RedFW.Server.Components.Players.inventory

setmetatable(RedFW.Server.Components.Players.inventory, {
    __call = function(_,  data, player)
        local self = setmetatable({}, RedFW.Server.Components.Players.inventory)
        self.serverId = player
        self.inventory = data
        RedFW.Server.Components.Players.inventory.list[self.serverId] = self

        function self:get()
            return self.inventory
        end

        function self:getWeight()
            local weight = 0
            for k, v in pairs(data) do
                weight = weight + (v.weight * v.count)
            end
            return weight
        end

        function self:addItem(itemName, count)
            local item = RedFW.Server.Components.Players.items:get(itemName)
            if (item) then
                if (self:getWeight() + (item:getWeight() * count) <= RedFW.Default.Inventory.weight) then
                    if (self.inventory[itemName]) then
                        self.inventory[itemName].count = self.inventory[itemName].count + count
                    else
                        self.inventory[itemName] = {
                            count = count,
                            label = item:getLabel(),
                            weight = item:getWeight()
                        }
                    end
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
                        ['@inventory'] = json.encode(self.inventory),
                        ['@identifier'] = RedFW.Server.Components.Players:get(self.serverId).identifier
                    })
                    RedFW.Shared.Event:triggerClientEvent('receiveInventory', self.serverId, self, self:getWeight())
                else
                    RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Vous ne pouvez pas porter plus de poids')
                end
            else
                RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Cet item n\'existe pas')
            end
        end

        function self:removeItem(name, count)
            if (self.inventory[name]) then
                if (self.inventory[name].count - count > 0) then
                    self.inventory[name].count = self.inventory[name].count - count
                else
                    self.inventory[name] = nil
                end
                MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
                    ['@inventory'] = json.encode(self.inventory),
                    ['@identifier'] = RedFW.Server.Components.Players:get(self.serverId).identifier
                })
                RedFW.Shared.Event:triggerClientEvent('receiveInventory', self.serverId, self, self:getWeight())
            end
        end

        return self
    end
})

RedFW.Shared.Event:registerEvent("getInventory", function()
    local _src = source
    if (_src) then
        local player = RedFW.Server.Components.Players:get(_src)
        if (player) then
            RedFW.Shared.Event:triggerClientEvent("receiveInventory", _src, player.inventory, player.inventory:getWeight())
        end
    end
end)

RegisterCommand('addItem', function(source, args)
    RedFW.Server.Components.Players:get(source).inventory:addItem(args[1], tonumber(args[2]))
end)