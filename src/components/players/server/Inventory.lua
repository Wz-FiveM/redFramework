RedFW.Server.Components.Players.inventory = {}

---get
---@param PlayerId number
---@return table
---@public 
function RedFW.Server.Components.Players.inventory:get(PlayerId)
    local self = RedFW.Server.Components.Players:get(PlayerId)
    if (self) then
        return self.inventory
    end
    return nil
end

---calculeWeight
---@return number
---@public 
function RedFW.Server.Components.Players.inventory:calculeWeight()
    local weight = 0
    for k, v in pairs(self.inventory) do
        weight = weight + (RedFW.Server.Components.Players.items:get(k).weight * v)
    end
    return weight
end

---canCarry
---@return boolean
---@public 
function RedFW.Server.Components.Players.inventory:canCarry()
    return self:calculeWeight() <= RedFW.Default.Inventory.weight
end

---addItem
---@param PlayerId number
---@param item string
---@return void
---@public
function RedFW.Server.Components.Players.inventory:addItem(PlayerId, item)
    local self = RedFW.Server.Components.Players:get(PlayerId)
    if (self) then
        table.insert(self.inventory, item)
        MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
            ['@inventory'] = json.encode(self.inventory),
            ['@identifier'] = self.identifier
        }, function()
            RedFW.Shared.Event:triggerClientEvent("onInventoryUpdate", PlayerId, self.inventory)
        end)
    end
end

---removeItem
---@param PlayerId number
---@param item string
---@return void
---@public
function RedFW.Server.Components.Players.inventory:removeItem(PlayerId, item)
    local self = RedFW.Server.Components.Players:get(PlayerId)
    if (self) then
        for k, v in pairs(self.inventory) do
            if (v == item) then
                table.remove(self.inventory, k)
                MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
                    ['@inventory'] = json.encode(self.inventory),
                    ['@identifier'] = self.identifier
                }, function()
                    RedFW.Shared.Event:triggerClientEvent("onInventoryUpdate", PlayerId, self.inventory)
                end)
                break
            end
        end
    end
end

---hasItem
---@param PlayerId number
---@param item string
---@return boolean
---@public
function RedFW.Server.Components.Players.inventory:hasItem(PlayerId, item)
    local self = RedFW.Server.Components.Players:get(PlayerId)
    if (self) then
        for k, v in pairs(self.inventory) do
            if (v == item) then
                return true
            end
        end
    end
    return false
end