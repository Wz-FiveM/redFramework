---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Main.lua] created at [25/09/2022 11:02]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

---@meta

RedFW.Server.Components.Players.listPlayers = {}
RedFW.Server.Components.Players.metatable = {}

setmetatable(RedFW.Server.Components.Players.metatable, {
    __call = function(_, serverId, datas)
        local self = setmetatable({}, RedFW.Server.Components.Players.metatable)
        self.serverId = serverId
        self.name = datas.firstname.." "..datas.lastname
        self.identifier = datas.identifier
        self.position = json.decode(datas.position)
        self.skin = json.decode(datas.skin)
        self.rank = RedFW.Server.Components.Players.rank:getRank(datas.rank)
        self.inventory = RedFW.Server.Components.Players.inventory(json.decode(datas.inventory), serverId)
        self.jobName = RedFW.Server.Components.Players.jobs:exist(datas.job)
        self.jobGrade = RedFW.Server.Components.Players.jobs:gradeExist(datas.job, datas.job_grade)
        self.account = RedFW.Server.Components.Players.accounts(serverId, datas.cash, datas.bank)
        function self:save()
            MySQL.Async.execute("UPDATE users SET position = @position, skin = @skin, inventory = @inventory, job = @job, job_grade = @job_grade, cash = @cash, bank = @bank WHERE identifier = @identifier", {
                ['@position'] = json.encode(self.position),
                ['@skin'] = json.encode(self.skin),
                ['@inventory'] = json.encode(self.inventory:get()),
                ['@job'] = self.jobName,
                ['@job_grade'] = self.jobGrade,
                ['@cash'] = self.account:getCash(),
                ['@bank'] = self.account:getBank(),
                ['@identifier'] = self.identifier
            })
        end
        RedFW.Server.Components.Players.listPlayers[serverId] = self
        print(('^2Player %s loaded^0'):format(GetPlayerName(self.serverId)))
        SetEntityCoords(GetPlayerPed(self.serverId), self.position.x, self.position.y, self.position.z)
        RedFW.Shared.Event:triggerClientEvent('receiveInventory', serverId, self.inventory, self.inventory:getWeight())
        RedFW.Shared.Event:triggerClientEvent('receiveJob', serverId, RedFW.Server.Components.Players.jobs:get(self.jobName), RedFW.Server.Components.Players.jobs:getGrade(self.jobName, self.jobGrade))
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
                MySQL.Async.execute('INSERT INTO users (identifier, skin, job, job_grade, cash, bank) VALUES (@identifier, @skin, @job, @job_grade, @cash, @bank)', {
                    ['@identifier'] = GetPlayerIdentifiers(_src)[1],
                    ['@skin'] = json.encode(RedFW.Default.Skin),
                    ['@job'] = RedFW.Default.Job.name,
                    ['@job_grade'] = RedFW.Default.Job.grade,
                    ["@cash"] = json.encode(RedFW.Default.Accounts["cash"]),
                    ["@bank"] = json.encode(RedFW.Default.Accounts["bank"])
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

function RedFW.Server.Components.Players:getPlayerByName(name)
    for _, v in pairs(RedFW.Server.Components.Players.listPlayers) do
        if (v.name == name) then
            return v
        end
    end
    return false
end

AddEventHandler("playerDropped", function()
    local _src = source
    if (_src) then
        local player = RedFW.Server.Components.Players:get(_src)
        if (player) then
            player:save()
            RedFW.Server.Components.Players.listPlayers[_src] = nil
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() == resource) then
        for _, v in pairs(RedFW.Server.Components.Players.listPlayers) do
            v:save()
        end
    end
end)