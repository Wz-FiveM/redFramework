RedFW.Server.Components.Players.jobs:new("cardealer", {
    label = "Concessionnaire",
    grades = {
        ["recrue"] = {
            salary = 25,
            label = "Concessionnaire - Recrue",
        },
        ["patron"] = {
            salary = 75,
            label = "Concessionnaire - Patron",
        },
    },
    positionBoss = vec3(-799.595581, -231.309891, 37.148682)
})

RedFW.Server.Components.Zone:add(vec3(-797.301086, -235.978027, 37.098145), function(source)
    RedFW.Shared.Event:triggerClientEvent("openCarDealer", source)
end, "cardealer")

RedFW.Server.Components.Callback:register("CarDealer:canBuy", function(_, price)
    local job = RedFW.Server.Components.Players.jobs:get("cardealer")
    if job.money >= price then
        return true
    end
    return false
end)

RedFW.Server.Components.Callback:register("CarDealer:buyVeh", function(_, price, props, plate)
    local job = RedFW.Server.Components.Players.jobs:get("cardealer")
    if job.money >= price then
        job.money = job.money - price
        RedFW.Server.Components.Players.jobs:saveMoney()
        RedFW.Server.Components.Players.vehicles:new("cardealer", props, plate, "inCardealer")
        return true
    end
    return false
end)

RedFW.Server.Components.Callback:register('CarDealer:getAllVeh', function()
    return RedFW.Server.Components.Players.vehicles:getAll()
end)

RedFW.Shared.Event:registerEvent("CarDealer:giveVeh", function(player, values)
    local job = RedFW.Server.Components.Players.jobs:get("cardealer")
    local vehicle = RedFW.Server.Components.Players.vehicles:get(values.id)
    if vehicle then
        if vehicle.situation == "inCardealer" then
            vehicle.situation = "out"
            vehicle.owner = player.identifier
            vehicle:save()
            job.money = job.money + values.price
            RedFW.Server.Components.Players.jobs:saveMoney()
        end
    end
end) 