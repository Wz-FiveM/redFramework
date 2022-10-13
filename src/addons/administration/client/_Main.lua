local main = RageUI.CreateMenu("Administration", "Menu d'administration", 0, 80)
local active = false
main.Closed = function()
    active = false
end
local actionsVehicle = RageUI.CreateSubMenu(main, "Actions véhicule", "Actions véhicule")
local playersActions = RageUI.CreateSubMenu(main, "Actions joueur", "Actions joueur")

local function menu()
    if active then 
        return 
    end
    local players = {}
    RedFW.Client.Components.Callback:triggerServer("administration:getAllPlayers", function(data)
        players = data
    end)
    active = true
    RageUI.Visible(main, true)
    CreateThread(function()
        while active do
            RageUI.IsVisible(main, function()
                RageUI.Button("Listes des joueurs", nil, {RightLabel = ">>"}, true, {}, playersActions)
                RageUI.Button("Actions véhicules", nil, {RightLabel = ">>"}, true, {}, actionsVehicle)
            end)
            RageUI.IsVisible(actionsVehicle, function()
                RageUI.Button("Faire apparaître un véhicule", nil, {RightLabel = ">>"}, true, {
                    onSelected = function()
                        local newVehicle = RedFW.Client.Functions:spawnVehicle(RedFW.Client.Functions:KeyboardInput("Nom du véhicule","", 15), GetEntityCoords(PlayerPedId()), 0.0)
                        TaskWarpPedIntoVehicle(PlayerPedId(), newVehicle, -1)
                    end
                })
                RageUI.Button("Supprimer votre véhicule", nil, {RightLabel = ">>"}, true, {
                    onSelected = function()
                        RedFW.Client.Functions:deleteCurrentVehicle()
                    end
                })
                RageUI.Separator("↓ ~b~Tous les véhicules~s~ ↓")
                for key, value in pairs(GetAllVehicleModels()) do
                    if GetLabelText(value) ~= "NULL" then
                        RageUI.Button(GetLabelText(value), nil, {RightLabel = ">>"}, true, {
                            onSelected = function()
                                RedFW.Client.Functions:deleteCurrentVehicle()
                                local newVehicle = RedFW.Client.Functions:spawnVehicle(value, GetEntityCoords(PlayerPedId()), 0.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), newVehicle, -1)
                            end
                        })
                    end
                end
            end)
            RageUI.IsVisible(playersActions, function()
                for key, value in pairs(players) do
                    RageUI.Button(value.name, nil, {RightLabel = "→→→"}, true, {})
                end
            end)
            Wait(0)
        end
    end)
end

Keys.Register("F1", "F1", "Ouvrir le menu d'administration", function()
    ExecuteCommand("admin")
end)

RedFW.Shared.Event:registerEvent("administration:openMenu", function()
    menu()
end)