local allZones = {}

RedFW.Shared.Event:registerEvent("loadZone", function(allZone)
    allZones = allZone
end)

CreateThread(function()
    RedFW.Shared.Event:triggerServerEvent("loadZone")
    while true do
        local inZone = false
        for _, value in pairs(allZones) do
            local distance = #(GetEntityCoords(PlayerPedId()) - value.position)
            if distance <= 10.0 then
                inZone = true
                DrawMarker(25, value.position.x, value.position.y, value.position.z - 0.98, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                if distance < 2.0 then
                    RedFW.Client.Functions:helpNotification("Press ~INPUT_CONTEXT~")
                    if IsControlJustPressed(0, 51) then
                        RedFW.Shared.Event:triggerServerEvent("zoneAction", value.id)
                    end
                end
            end
        end
        if inZone then
            Wait(0)
        else
            Wait(1000)
        end
    end
end)