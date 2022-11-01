RedFW.Shared.Event:registerEvent("receiveJob", function(job, grade)
    RedFW.Client.Components.Player.job = job
    RedFW.Client.Components.Player.jobGrade = grade
    print(('^2Job %s with grade %s (salary : %i$) applied^0'):format(job.label, grade.label, grade.salary))
end)

Keys.Register("F6", "job", "Open Job Menu", function()
    RedFW.Shared.Event:triggerEvent("openJobMenu")
end)

local active = false
local main = RageUI.CreateMenu("Job", "Menu")
main.Closed = function()
    active = false
end
local memberList = RageUI.CreateSubMenu(main, "Job", "Liste des membres")
local gradesList = RageUI.CreateSubMenu(main, "Job", "Liste des grades")

local function openMenu(name, label, grades, membres)
    if active then return end
    local index = 1
    local availableGrade = {"Virer"}
    for key, value in pairs(grades) do
        table.insert(availableGrade, value.label)
    end
    active = true
    RageUI.Visible(main, true)
    CreateThread(function()
        while active do
            Wait(1)
            RageUI.IsVisible(main, function()
                RageUI.Separator("Job : "..label)
                RageUI.Button("Liste des membres", nil, {RightLabel = ">>"}, true, {}, memberList)
                RageUI.Button("Liste des grades", nil, {RightLabel = ">>"}, true, {}, gradesList)
            end)
            RageUI.IsVisible(gradesList, function()
                for key, value in pairs(grades) do
                    RageUI.Button(value.label, nil, {RightLabel = value.salary.."$"}, true, {
                        
                    
                    })
                end
            end)
            RageUI.IsVisible(memberList, function()
                for key, value in pairs(membres) do
                    RageUI.List("Membre : "..value.name, availableGrade, index, nil, {}, true, {
                        onListChange = function(Index, Item)
                            index = Index
                        end,
                        onSelected = function(Index, Item)
                            RedFW.Shared.Event:triggerServerEvent("changeJobGradeWithUserName", name, value.name, availableGrade[Index].name)
                        end
                    })
                end
            end)
        end
    end)
end

RedFW.Shared.Event:registerEvent("openJobMenu", function(name, label, grades, membres)
    openMenu(name, label, grades, membres)
end)