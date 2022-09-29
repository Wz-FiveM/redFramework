RedFW.Server.Components.Players.inventory = {}
RedFW.Server.Components.Players.inventory.__index = RedFW.Server.Components.Players.inventory

setmetatable(RedFW.Server.Components.Players.inventory, {
    __call = function (_, data, maxWeight, save)
        local self = setmetatable({}, RedFW.Server.Components.Players.inventory)

        self.save = save
        self.maxWeight = maxWeight or RedFW.Default.Inventory.weight
        self.data = data
        self.weight = self:calculateWeight()

        if self.maxWeight < self.weight then
            print(("[^4Framework^0] Cheater connecting find Weight [%s] > maxWeight [%s]"):format(self.weight, self.maxWeight))
        end
        return self
    end,
})

---calculateWeight
function RedFW.Server.Components.Players.inventory:calculateWeight()
    local weight = 0
    for _, v in pairs(self.data) do
        weight += (v.weight * v.count)
    end
    return weight
end

---removeItem
---@param item string
---@param number number
function RedFW.Server.Components.Players.inventory:removeItem(item, number)
    if not self:haveItem(item) then
        return
    end
    if self.data[item].count <= number then
        self.weight -= (self.data[item].weight * self.data[item].count)
        self.data[item] = nil
        self:save()
        return
    end
    self.weight -= (self.data[item].weight * number)
    self.data[item].count -= number
    self:save()
    return self.data[item].count
end

---canCarry
---@param item string
---@param number number
function RedFW.Server.Components.Players.inventory:canCarry(item, number)
    if not self.data[item] then
        if not RedFW.Server.Components.Players.items:itemExist(item) then
            return false
        end
        return (self.maxWeight >= ((RedFW.Server.Components.Players.inventory:getWeight(item) * number) + self.weight))
    end
    return (self.maxWeight >= ((self.data[item].weight * number) + self.weight))
end

---addItem
---@param item string
---@param number number
function RedFW.Server.Components.Players.inventory:addItem(item, number)
    if not RedFW.Server.Components.Players.items:itemExist(item) then
        return
    end
    if not self:canCarry(item, number) then
        return
    end
    if not self.data[item] then
        local itemData = RedFW.Server.Components.Players.inventory:getItem(item)
        self.data[item] = {
            name = itemData.name,
            label = itemData.label,
            weight = itemData.weight,
            count = number,
            useCallback = useCallback
        }
        self.weight += (self.data[item].weight * number)
        self:save()
        return self.data[item].count
    end
    self.weight += (self.data[item].weight * number)
    self.data[item].count += number
    self:save()
    return self.data[item].count
end

---haveItem
---@param item string
function RedFW.Server.Components.Players.inventory:haveItem(item)
    return (self.data[item] ~= nil)
end

---getItem
---@param item string
function RedFW.Server.Components.Players.inventory:getItem(item)
    if not self:haveItem(item) then
        return
    end
    return self.data[item]
end

---useItem
---@param item string
function RedFW.Server.Components.Players.inventory:useItem(item)
    if not (self:getItemCount(item) ~= 0) then
        return
    end
    RedFW.Server.Components.Players.inventory:getItem(item).useCallback(function(number)
        self:removeItem(item, number or 1)
    end)
end


---getItemCount
---@param item string
function RedFW.Server.Components.Players.inventory:getItemCount(item)
    if not self:haveItem(item) then
        return 0
    end
    return self.data[item].count
end

---getInventory
function RedFW.Server.Components.Players.inventory:getInventory()
    return self.data
end

---getMaxWeight
function RedFW.Server.Components.Players.inventory:getMaxWeight()
    return self.maxWeight
end

---setMaxWeight
function RedFW.Server.Components.Players.inventory:setMaxWeight()
    return self.maxWeight
end

---getWeight
function RedFW.Server.Components.Players.inventory:getWeight()
    return self.weight
end

---save
function RedFW.Server.Components.Players.inventory:save()
    self:save()
end

RegisterCommand('giveitem', function(source, args)
    local player = RedFW.Server.Components.Players:get(tonumber(args[1]))
    if args[2] == nil then
        return print("[^4Framework^0] Usage: /giveitem [item] [count]")
    end
    if args[3] == nil then
        return print("[^4Framework^0] Usage: /giveitem [item] [count]")
    end
    player.inventory:addItem(args[2], tonumber(args[3]))
    player.inventory:save()
    RedFW.Shared.Event:triggerClientEvent("receiveInventory", player.serverId, player.inventory:getInventory(), {player.inventory:getWeight(), player.inventory:getMaxWeight()})
end)