RedFW.Client.Components.Vehicle = {}
RedFW.Client.Components.Vehicle.list = {}

CreateThread(function()
    Wait(1000)
    RedFW.Client.Components.Callback:triggerServer("getVehicleList", function(vehicles)
        for k, v in pairs(vehicles) do
            RedFW.Client.Components.Vehicle.list[v.id] = v
        end
    end)
    print("^2Vehicles loaded^0")
end)

function RedFW.Client.Components.Vehicle:getAll()
    return RedFW.Client.Components.Vehicle.list
end

function RedFW.Client.Components.Vehicle:refresh()
    RedFW.Client.Components.Callback:triggerServer("getVehicleList", function(vehicles)
        for k, v in pairs(vehicles) do
            RedFW.Client.Components.Vehicle.list[v.id] = v
        end
    end)
end