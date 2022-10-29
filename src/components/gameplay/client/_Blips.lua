---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Blips.lua] created at [29/10/2022 11:37]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

local Blips = {}

RedFW.Shared.Event:registerEvent('receiveBlips', function(blips)  
    Blips = blips
    for i, v in pairs(blips) do
        if not DoesBlipExist(Blips[i]) then
            Blips[i] = AddBlipsForCoord(v.position.x, v.position.y, v.position.z)
            SetBlipSprite(Blips[i], v.sprite)
            SetBlipDisplay(Blips[i], v.display)
            SetBlipScale(Blips[i], v.scale)
            SetBlipColour(Blips[i], v.color)
            SetBlipAsShortRange(Blips[i], v.shortRange)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(Blips[i])
        end
    end
end)