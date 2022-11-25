--[[
  This file is part of Amaya.
  Created at 25/11/2022 18:23
  
  Copyright (c) Amaya - All Rights Reserved
  
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]
---@author Wezor

RedFW.Client.Functions = {}

---GetHashKey
---@param string
---@return model
---@public
function RedFW.Client.Functions:hash(string)
    return GetHashKey(string)
end

RegisterCommand("coords", function()
    coords = GetEntityCoords(PlayerPedId())
    print(coords)
    RedFW.Shared.Event:log("test")
end)

RegisterCommand("revive", function()
    local coords, heading = GetEntityCoords(PlayerPedId()), GetEntityHeading()
    NetworkResurrectLocalPlayer(coords, heading)
end)

RegisterCommand("veh_spawn", function(_,args)
    if (#args < 1) then
        print("Merci de renseigner le modèle du véhicule")
        return
    end
    local model<const> = GetHashKey(args[1])
    local coords<const> = GetEntityCoords(PlayerPedId())
    local heading<const> = GetEntityHeading(PlayerPedId())

    if (not (IsModelValid(model))) then
        print("Model veh invalid")
        return
    end
    RequestModel(model)
    RequestModel(model)
    while (not (HasModelLoaded(model))) do
        Wait(100)
    end
    local vehicle<const> = CreateVehicle(model, spawnCoords, spawnHeading, true)
    local duplie = ClonePed(PlayerPedId(),false,false,false)

    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetPedIntoVehicle(duplie,vehicle,0 )
end)

