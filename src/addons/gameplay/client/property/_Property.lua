RedFW.Client.Addons = {}
RedFW.Client.Addons.Property = {}

RedFW.Shared.Event:registerEvent("loadProperty", function(property)
    DoScreenFadeOut(100)
    CreateThread(function()
        RedFW.Shared.Event:triggerServerEvent('property:chest', property.id)
        Citizen.Wait(1000)
        SetEntityCoords(PlayerPedId(), vector3(json.decode(property.positionInside).x, json.decode(property.positionInside).y, json.decode(property.positionInside).z - 0.98))
        DoScreenFadeIn(1000)
        while (true) do
            local inZone = false
            local distanceFromExitZone = #(GetEntityCoords(PlayerPedId()) - vector3(json.decode(property.positionInside).x, json.decode(property.positionInside).y, json.decode(property.positionInside).z))
            if (distanceFromExitZone < 10.0) then
                inZone = true
                DrawMarker(25, json.decode(property.positionInside).x, json.decode(property.positionInside).y, json.decode(property.positionInside).z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, false, false, false, false, false)
                if (distanceFromExitZone < 1.0) then
                    if (IsControlJustPressed(0, 51)) then
                        DoScreenFadeOut(100)
                        Citizen.Wait(1000)
                        SetEntityCoords(PlayerPedId(), vector3(json.decode(property.positionOutside).x, json.decode(property.positionOutside).y, json.decode(property.positionOutside).z - 0.98))
                        DoScreenFadeIn(1000)
                        break
                    end;
                end;
            end;
            local distanceFromExitZone = #(GetEntityCoords(PlayerPedId()) - vector3(json.decode(property.chestPosition).x, json.decode(property.chestPosition).y, json.decode(property.chestPosition).z))
            if (distanceFromExitZone < 10.0) then
                inZone = true
                DrawMarker(25, json.decode(property.chestPosition).x, json.decode(property.chestPosition).y, json.decode(property.chestPosition).z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 20, 192, 0, 70, false, true, 2, false, false, false, false)
                if (distanceFromExitZone < 1.0) then
                    if (IsControlJustPressed(0, 51)) then
                        ShowPropertyChest(property.name, property.id)
                    end;
                end;
            end;
            if (inZone) then
                Wait(0)
            else
                Wait(1000)
            end;
        end;
    end)
end)