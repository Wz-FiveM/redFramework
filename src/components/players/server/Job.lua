RedFW.Server.Components.Players.jobs = {}
RedFW.Server.Components.Players.jobs.list = {}
RedFW.Server.Components.Players.jobs.__index = RedFW.Server.Components.Players.jobs

function RedFW.Server.Components.Players.jobs:new(name, data)
    local self = setmetatable({}, RedFW.Server.Components.Players.jobs)
    self.name = name
    self.label = data.label
    self.grades = data.grades
    self.money = RedFW.Server.Components.Players.jobs:getMoney(self.name)
    if data.positionBoss ~= nil then
        RedFW.Server.Components.Zone:add(data.positionBoss, function(src)
            local membres = {}
            MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @job", {["@job"] = self.name}, function(result)
                for _,v in pairs(result) do
                    table.insert(membres, {
                        name = v.firstname .. " " .. v.lastname,
                        grade = v.job_grade
                    })
                end
                RedFW.Shared.Event:triggerClientEvent("openJobMenu", src, self.name, self.label, self.grades, membres)
            end)
        end, self.name)
    end
    RedFW.Server.Components.Players.jobs.list[name] = self
    print("^2Registered job: " .. name.."^0")
    return self
end

function RedFW.Server.Components.Players.jobs:get(jobName)
    return RedFW.Server.Components.Players.jobs.list[jobName]
end

function RedFW.Server.Components.Players.jobs:getAll()
    return RedFW.Server.Components.Players.jobs.list
end

function RedFW.Server.Components.Players.jobs:getMoney(jobName)
    local savedMoney = json.decode(LoadResourceFile(GetCurrentResourceName(), "src/constant/server/jobsMoney.json"))
    if savedMoney[jobName] then
        return savedMoney[jobName]
    end
    savedMoney[jobName] = 0
    SaveResourceFile(GetCurrentResourceName(), "src/constant/server/jobsMoney.json", json.encode(savedMoney), -1)
    return 0
end

function RedFW.Server.Components.Players.jobs:saveMoney()
    local money = {}
    for k, v in pairs(RedFW.Server.Components.Players.jobs.list) do
        money[k] = v.money
    end
    RedFW.Server.Functions:file_write("resources/redFramework/src/constant/server/jobsMoney.json", json.encode(money))
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

RedFW.Shared.Event:registerEvent('changeJobGradeWithUserName', function(job, nameUser, grade)
    local player = RedFW.Server.Components.Players:getPlayerByName(nameUser)
    if player then
        RedFW.Server.Components.Players.jobs:setJobPlayer(player.serverId, job, grade)
        return
    end
    MySQL.Async.fetchAll("SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname", {["@firstname"] = nameUser[1], ["@lastname"] = nameUser[2]}, function(result)
        if result[1] then
            MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                ['@identifier'] = result[1].identifier,
                ['@job'] = job,
                ['@job_grade'] = grade
            })
        end
    end)
end)