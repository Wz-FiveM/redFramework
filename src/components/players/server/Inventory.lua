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
        RedFW.Server.Components.Players.inventory.list[serverId] = self
        return self
    end
})

---get
---@param serverId number
---@return table
---@public
function RedFW.Server.Components.Players.inventory:get(serverId)
    return RedFW.Server.Components.Players.inventory.list[serverId]
end

---getAll
---@return table
---@public
function RedFW.Server.Components.Players.inventory:getAll()
    return RedFW.Server.Components.Players.inventory.list
end

RegisterCommand('getInv', function(source, args)
    local _src = tonumber(args[1])
    local inv = RedFW.Server.Components.Players.inventory:get(_src)
    print(json.encode(inv.data))
end)