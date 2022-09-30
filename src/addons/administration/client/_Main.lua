local main = RageUI.CreateMenu("Administration", "Menu d'administration", 0, 80)
local active = false
main.Closed = function()
    active = false
end

local function menu()
    if active then 
        return 
    end
    RedFW.Client.Components.Callback:triggerServerAsync("administration:getAllPlayers", function(data)
        print(json.encode(data))
    end)
    active = true
    RageUI.Visible(main, true)
    CreateThread(function()
        while active do
            RageUI.IsVisible(main, function()
                RageUI.Button("Gestion des joueurs", nil, {RightLabel = "→→→"}, true, {})
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