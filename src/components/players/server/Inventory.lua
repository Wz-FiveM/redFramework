RedFW.Server.Components.Players.inventory = {}
RedFW.Server.Components.Players.inventory.list = {}

setmetatable(RedFW.Server.Components.Players.inventory, {
    __call = function(_, data, serverId)

        local self = setmetatable({}, RedFW.Server.Components.Players.inventory)
        self.data = data
        self.serverId = serverId

        self.save = function()
            MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
                ['@inventory'] = json.encode(self.data),
                ['@identifier'] = RedFW.Server.Components.Players.listPlayers[serverId].identifier
            }, function()
                print(('^2Inventory of %s saved^0'):format(GetPlayerName(serverId)))
            end)
        end

        self.getWeight = function()
            local weight = 0
            for k, v in pairs(self.data) do
                weight = weight + (v.weight * v.count)
            end
            return weight
        end

        function self:get()
            return self.data
        end

        function self:getItem(name)
            return self.data[name]
        end

        function self:addItem(name, quantity)
            local player = RedFW.Server.Components.Players:get(self.serverId)
            local item = RedFW.Server.Components.Players.items:get(name)
            if item then
                if player.inventory:getWeight() + (item.getWeight() * quantity) <= RedFW.Default.Inventory.weight then
                    if self:getItem(name) then
                        player.inventory:getItem(name).count = player.inventory:getItem(name).count + quantity
                    else
                        player.inventory:addItem(name, quantity)
                    end
                    RedFW.Shared.Event:triggerClientEvent('receiveInventory', self.serverId, player.inventory, player.inventory.getWeight())
                    self.save()
                    return true
                else
                    RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Vous n\'avez pas assez de place dans votre inventaire')
                    return false
                end
            else
                RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Cet item n\'existe pas')
                return false
            end
        end

        function self:removeItem(name, quantity)
            local player = RedFW.Server.Components.Players:get(self.serverId)
            local item = RedFW.Server.Components.Players.items:get(name)
            if item then
                if self:getItem(name) then
                    if player.inventory:getItem(name).count - quantity >= 0 then
                        player.inventory:getItem(name).count = player.inventory:getItem(name).count - quantity
                        RedFW.Shared.Event:triggerClientEvent('receiveInventory', self.serverId, player.inventory, player.inventory.getWeight())
                        self.save()
                        return true
                    else
                        RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Vous n\'avez pas assez de cet item')
                        return false
                    end
                else
                    RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Vous n\'avez pas cet item')
                    return false
                end
            else
                RedFW.Shared.Event:triggerClientEvent('receiveNotification', self.serverId, 'Cet item n\'existe pas')
                return false
            end
        end

        RedFW.Server.Components.Players.inventory.list[serverId] = self

        return self
    end
})

---get
---@param serverId number
---@return table
---@public
function RedFW.Server.Components.Players.inventory:get()
    return RedFW.Server.Components.Players.inventory.list[self.serverId]
end

---getAll
---@return table
---@public
function RedFW.Server.Components.Players.inventory:getAll()
    return RedFW.Server.Components.Players.inventory.list
end