---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Main.lua] created at [25/09/2022 11:02]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Server.Components.Players = {}


RedFW.Server.Components.Players.metatable = {}

setmetatable(RedFW.Server.Components.Players.metatable, {
    __call = function(__call, serverId)
        local self = setmetatable({}, RedFW.Server.Components.Players.metatable)
        self.serverId = serverId
        print(('Player %i loaded'):format(self.serverId))
        return self
    end
})

RedFW_Shared_Event:registerEvent("onPlayerLoaded", function()
    local _src = source
    if (_src) then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIdentifiers(_src)[1]
        }, function(result)
            if (result[1]) then
                RedFW.Server.Components.Players.metatable(_src, result[1])
            else
                MySQL.Async.execute('INSERT INTO users (identifier) VALUES (@identifier)', {
                    ['@identifier'] = GetPlayerIdentifiers(_src)[1]
                }, function()
                    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = GetPlayerIdentifiers(_src)[1]
                    }, function(result)
                        RedFW.Server.Components.Players.metatable(_src, result[1])
                    end)
                end)
            end
        end)
    end;
end)