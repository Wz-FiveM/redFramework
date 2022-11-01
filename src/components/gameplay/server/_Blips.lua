---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Blips.lua] created at [29/10/2022 11:37]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Server.Components.Gameplay = {}
RedFW.Server.Components.Gameplay.Blips = {}
RedFW.Server.Components.Gameplay.Blips.list = {}
RedFW.Server.Components.Gameplay.Blips.__index = RedFW.Server.Components.Gameplay.Blips

setmetatable(RedFW.Server.Components.Gameplay.Blips, {
    __call = function (_, name, position, color, sprite, scale, shortRange)
        local self = setmetatable({}, RedFW.Server.Components.Gameplay.Blips)
        self.name = name
        self.position = position
        self.color = color
        self.sprite = sprite
        self.scale = scale
        self.shortRange = shortRange
        self.id = #RedFW.Server.Components.Gameplay.Blips.list + 1
        RedFW.Server.Components.Gameplay.Blips.list[self.id] = self
        return self
    end,
})

function RedFW.Server.Components.Gameplay.Blips:new(name, position, color, sprite, scale, shortRange)
    return RedFW.Server.Components.Gameplay.Blips(name, position, color, sprite, scale, shortRange)
end

function RedFW.Server.Components.Gameplay.Blips:get(id)
    return RedFW.Server.Components.Gameplay.Blips.list[id]
end

function RedFW.Server.Components.Gameplay.Blips:destroy()
    RedFW.Server.Components.Gameplay.Blips.list[self.id] = nil
end

RedFW.Shared.Event:registerEvent("getBlips", function()
    RedFW.Shared.Event:triggerClientEvent("receiveBlips", source, RedFW.Server.Components.Gameplay.Blips.list)
end)