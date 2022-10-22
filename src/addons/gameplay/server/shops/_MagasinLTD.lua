---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_MagasinLTD.lua] created at [22/10/2022 10:50]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

for k, v in pairs(MagasinLTD) do
    RedFW.Server.Components.Zone:add(v.positionCheckOrder, function(source)
        RedFW.Shared.Event:triggerClientEvent("loadLtdOrder", source)
    end)
    RedFW.Server.Components.Zone:add(v.positionWaterItem, function(source)
        RedFW.Shared.Event:triggerClientEvent("loadLtdWater", source)
    end)
    RedFW.Server.Components.Zone:add(v.positionFoodItem, function(source)
        RedFW.Shared.Event:triggerClientEvent("loadLtdFood", source)
    end)
end

RedFW.Shared.Event:registerEvent('buyLtdOrder', function(order)
    local _src = source
    local player = RedFW.Server.Components.Players:get(_src)
    local total = 0
    for i, v in pairs(order) do
        total = total + (v.price * v.quantity)
        if player.account:getCash() >= total then
            player.account:removeCash(total)
            player.inventory:addItem(i, v.quantity)
        else
            RedFW.Shared.Event:triggerClientEvent('receiveNotification', _src, 'Vous n\'avez pas assez d\'argent')
        end
    end
end)