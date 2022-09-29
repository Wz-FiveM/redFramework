---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Main.lua] created at [25/09/2022 11:02]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Server.Components.Players.listPlayers = {}
RedFW.Server.Components.Players.metatable = {}

setmetatable(RedFW.Server.Components.Players.metatable, {
    __call = function(_, serverId, datas)
        local self = setmetatable({}, RedFW.Server.Components.Players.metatable)
        self.serverId = serverId
        self.identifier = datas.identifier
        self.skin = json.decode(datas.skin)
        self.inventory = RedFW.Server.Components.Players.inventory(json.decode(datas.inventory), serverId)
        RedFW.Server.Components.Players.listPlayers[serverId] = self
        print(('^2Player %s loaded^0'):format(GetPlayerName(self.serverId)))
        RedFW.Shared.Event:triggerClientEvent('receiveInventory', serverId, self.inventory)
        return self
    end
})

RedFW.Shared.Event:registerEvent("onPlayerLoaded", function()
    local _src = source
    if (_src) then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIdentifiers(_src)[1]
        }, function(result)
            if (result[1]) then
                RedFW.Server.Components.Players.metatable(_src, result[1])
            else
                MySQL.Async.execute('INSERT INTO users (identifier, skin) VALUES (@identifier, @skin)', {
                    ['@identifier'] = GetPlayerIdentifiers(_src)[1],
                    ['@skin'] = json.encode(RedFW.Default.Skin)
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

---get 
---@param serverId number
---@return table
---@public
function RedFW.Server.Components.Players:get(serverId)
    return RedFW.Server.Components.Players.listPlayers[serverId]
end

---getAll
---@return table
---@public
function RedFW.Server.Components.Players:getAll()
    return RedFW.Server.Components.Players.listPlayers
end