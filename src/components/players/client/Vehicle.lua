RedFW.Client.Components.Player.vehicle = {}
RedFW.Client.Components.Player.vehicle.list = {}

CreateThread(function()
    Wait(1000)
    RedFW.Client.Components.Callback:triggerServer("getVehicleList", function(vehicles)
        for k, v in pairs(vehicles) do
            RedFW.Client.Components.Player.vehicle.list[v.id] = v
        end
    end)
    print("^2Vehicles loaded^0")
end)