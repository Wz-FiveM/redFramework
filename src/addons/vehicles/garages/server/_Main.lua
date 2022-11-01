local Garage = {
    {
        position = vec3(-899.432983, -153.705490, 41.883545),
        spawn = vec3(-901.885742, -159.903290, 41.866699),
        heading = 28.34645652771
    }
}

for key, value in pairs(Garage) do
    RedFW.Server.Components.Zone:add(value.position, function(source)
        RedFW.Shared.Event:triggerClientEvent("openGarage", source, value.spawn, value.heading)
    end)
    RedFW.Server.Components.Gameplay.Blips:new("Garage", value.position, 1, 357, 0.5, true)
end