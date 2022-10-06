local main = RageUI.CreateMenu("Administration", "Menu d'administration", 0, 80)
local active = false
main.Closed = function()
    active = false
end

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