RedFW.Server.Components.Players.jobs = {}
RedFW.Server.Components.Players.jobs.list = {}
RedFW.Server.Components.Players.jobs.__index = RedFW.Server.Components.Players.jobs

function RedFW.Server.Components.Players.jobs:new(name, data)
    local self = setmetatable({}, RedFW.Server.Components.Players.jobs)
    self.name = name
    self.label = data.label
    self.grades = data.grades
    RedFW.Server.Components.Players.jobs.list[name] = self
    return self
end

function RedFW.Server.Components.Players.jobs:get(jobName)
    return RedFW.Server.Components.Players.jobs.list[jobName]
end

function RedFW.Server.Components.Players.jobs:getGrade(jobName, gradeName)
    return RedFW.Server.Components.Players.jobs.list[jobName].grades[gradeName]
end

function RedFW.Server.Components.Players.jobs:exist(jobName)
    if RedFW.Server.Components.Players.jobs.list[jobName] ~= nil then
        return jobName
    end
    return "unemployed"
end

function RedFW.Server.Components.Players.jobs:gradeExist(jobName, gradeName)
    if RedFW.Server.Components.Players.jobs.list[jobName] then
        if RedFW.Server.Components.Players.jobs.list[jobName].grades[gradeName] then
            return gradeName
        end
    end
    return "unemployed"
end

function RedFW.Server.Components.Players.jobs:setJobPlayer(serverId, jobName, gradeName)
    local player = RedFW.Server.Components.Players:get(serverId)
    if player ~= nil then
        player.jobName = RedFW.Server.Components.Players.jobs:exist(jobName)
        player.jobGrade = RedFW.Server.Components.Players.jobs:gradeExist(jobName, gradeName)
        MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
            ['@identifier'] = player.identifier,
            ['@job'] = player.jobName,
            ['@job_grade'] = player.jobGrade
        }, function()
            RedFW.Shared.Event:triggerClientEvent('receiveJob', serverId, RedFW.Server.Components.Players.jobs:get(player.jobName), RedFW.Server.Components.Players.jobs:getGrade(player.jobName, player.jobGrade))
        end)
    end
end

RedFW.Server.Components.Players.jobs:new("unemployed", { --Don't touch this
    label = "Sans-Emploie",
    grades = {
        ["unemployed"] = {
            salary = 25,
            label = "Sans-Emploie",
        }
    }
})

CreateThread(function()
    while true do
        Wait(60000 * 5)
        local players = RedFW.Server.Components.Players:getAll()
        print(('%s Players has receive salary in bank account'):format(#players))
        for _, player in pairs(players) do
            local players = RedFW.Server.Components.Players:get(player.serverId)
            local grade = RedFW.Server.Components.Players.jobs:getGrade(player.jobName, player.jobGrade)
            if grade.salary > 0 then
                players.account:addBank(grade.salary)
                RedFW.Shared.Event:triggerClientEvent("receiveNotification", player.serverId, "Vous avez reçu votre salaire de "..grade.salary.."$")
            end
        end
    end
end)

RegisterCommand('setJob', function(source, args)
    RedFW.Server.Components.Players.jobs:setJobPlayer(tonumber(args[1]), args[2], args[3])
end)