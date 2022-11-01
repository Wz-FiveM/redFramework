RedFW.Server.Components.Players.vehicles = {}
RedFW.Server.Components.Players.vehicles.list = {}
RedFW.Server.Components.Players.vehicles.__index = RedFW.Server.Components.Players.vehicles

setmetatable(RedFW.Server.Components.Players.vehicles, {
    __call = function(_, id, owner, props, plate, situation)
        local self = setmetatable({}, RedFW.Server.Components.Players.vehicles)
        self.id = id
        self.owner = owner
        self.props = props
        self.plate = plate
        self.situation = situation
        RedFW.Server.Components.Players.vehicles.list[id] = self
        return self
    end,
})

function RedFW.Server.Components.Players.vehicles:get(id)
    return RedFW.Server.Components.Players.vehicles.list[id]
end

function RedFW.Server.Components.Players.vehicles:getAll()
    return RedFW.Server.Components.Players.vehicles.list
end

function RedFW.Server.Components.Players.vehicles:ifPlateExist(plate)
    for k, v in pairs(RedFW.Server.Components.Players.vehicles.list) do
        if v.plate == plate then
            return true
        end
    end
    return false
end

function RedFW.Server.Components.Players.vehicles:generatePlate()
    local plate = ""
    for i = 1, 8 do
        plate = plate .. string.char(math.random(65, 90))
    end
    if RedFW.Server.Components.Players.vehicles:ifPlateExist(plate) then
        return RedFW.Server.Components.Players.vehicles:generatePlate()
    else
        return plate
    end
end

function RedFW.Server.Components.Players.vehicles:save()
    MySQL.Async.execute("UPDATE `vehicles` SET `props` = @props, `plate` = @plate, `situation` = @situation WHERE `id` = @id", {
        ['@id'] = self.id,
        ['@props'] = json.encode(self.props),
        ['@plate'] = self.plate,
        ['@situation'] = self.situation
    })
end

function RedFW.Server.Components.Players.vehicles:new(owner, props, plate, situation)
    MySQL.Async.execute("INSERT INTO `vehicles` (`owner`, `props`, `plate`, `situation`) VALUES (@owner, @props, @plate, @situation)", {
        ['@owner'] = owner,
        ['@props'] = json.encode(props),
        ['@plate'] = RedFW.Server.Components.Players.vehicles:generatePlate(),
        ['@situation'] = situation
    }, function(id)
        RedFW.Server.Components.Players.vehicles(id, owner, props, RedFW.Server.Components.Players.vehicles:generatePlate(), situation)
    end)
end

function RedFW.Server.Components.Players.vehicles:delete()
    MySQL.Async.execute("DELETE FROM `vehicles` WHERE `id` = @id", {
        ['@id'] = self.id
    })
    RedFW.Server.Components.Players.vehicles.list[self.id] = nil
end

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM `vehicles`", {}, function(vehicles)
        for k, v in pairs(vehicles) do
            RedFW.Server.Components.Players.vehicles(v.id, v.owner, json.decode(v.props), v.plate, v.situation)
            print("^2Vehicle " .. v.plate .." loaded^0")
        end
    end)
end)

RedFW.Server.Components.Callback:register("getVehicleList", function(source)
    local player = RedFW.Server.Components.Players:get(source)
    local vehicles = {}
    for k, v in pairs(RedFW.Server.Components.Players.vehicles.list) do
        if v.owner == player.identifier then
            table.insert(vehicles, v)
        end
    end
    return vehicles
end)