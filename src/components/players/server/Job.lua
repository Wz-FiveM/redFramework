RedFW.Server.Components.Players.jobs = {}
RedFW.Server.Components.Players.jobs.list = {}
RedFW.Server.Components.Players.jobs.__index = RedFW.Server.Components.Players.jobs

function RedFW.Server.Components.Players.jobs.new(name, data)
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

function RedFW.Server.Components.Players.jobs:getGrade(gradeName)
    if self.grades[gradeName] then
        return self.grades[gradeName]
    end
end

function RedFW.Server.Components.Players.jobs:exist(jobName)
    if RedFW.Server.Components.Players.jobs.list[jobName] ~= nil then
        return jobName
    end
    return "unemployed"
end

function RedFW.Server.Components.Players.jobs:gradeExist(jobName, gradeName)
    if RedFW.Server.Components.Players.jobs.list[jobName].grades[gradeName] ~= nil then
        return gradeName
    end
    return "unemployed"
end

RedFW.Server.Components.Players.jobs.new("unemployed", { --Don't touch this
    label = "Sans-Emploie",
    grades = {
        ["unemployed"] = {
            salary = 25,
            label = "Sans-Emploie",
        }
    }
})


-- RedFW.Server.Components.Players.jobs.new("police", {
--     label = "Policier",
--     grades = {
--         ["recrue"] = {
--             salary = 100,
--             label = "Recrue",
--         },
--         ["sergent"] = {
--             salary = 200,
--             label = "Sergent",
--         },
--         ["lieutenant"] = {
--             salary = 300,
--             label = "Lieutenant",
--         },
--         ["chef"] = {
--             salary = 400,
--             label = "Chef",
--         },
--     }
-- })

-- local job = RedFW.Server.Components.Players.jobs:get("police")
-- job:getGrade("recrue")