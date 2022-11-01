---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Blips.lua] created at [29/10/2022 11:37]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

local AllBlips = {}

SetTimeout(2000, function()
    RedFW.Shared.Event:triggerServerEvent("getBlips")
end)

RedFW.Shared.Event:registerEvent('receiveBlips', function(blips)  
    AllBlips = blips
end)

CreateThread(function()
    local blips = {}
    while true do
        Wait(5000)
        for i, v in pairs(AllBlips) do
            if not DoesBlipExist(blips[i]) then
                if (v.job ~= nil) then
                    if (RedFW.Client.Components.Player.job.name == v.job) then
                        blips[i] = AddBlipForCoord(v.position)
                        SetBlipSprite(blips[i], v.sprite)
                        SetBlipScale(blips[i], v.scale)
                        SetBlipColour(blips[i], v.color)
                        SetBlipAsShortRange(blips[i], true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(v.text)
                        EndTextCommandSetBlipName(blips[i])
                    end
                else
                    blips[i] = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                    SetBlipSprite(blips[i], v.sprite)
                    SetBlipScale(blips[i], v.scale)
                    SetBlipColour(blips[i], v.color)
                    SetBlipAsShortRange(blips[i], true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(v.text)
                    EndTextCommandSetBlipName(blips[i])
                end
            else
                if v.job ~= nil and v.job ~= RedFW.Client.Components.Player.job.name then
                    RemoveBlip(blips[i])
                    blips[i] = nil
                end
            end
        end
    end
end)