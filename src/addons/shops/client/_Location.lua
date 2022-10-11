local active = false
local main = RageUI.CreateMenu("Location", "Location", 0, 80)
main.Closed = function()
    active = false
end

local availableVehicles = {
    ["blista"] = {price = 150, label = "Blista"}
}

local function menu()
    if active then
        return
    end
    active = true
    RageUI.Visible(main, true)
    CreateThread(function()
        while active do
            Wait(1)
            RageUI.IsVisible(main, function()
                for _, value in pairs(availableVehicles) do
                    RageUI.Button(value.label, nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            local vehicle = RedFW.Client.Functions:spawnVehicle("sultanrs", GetEntityCoords(PlayerPedId()), 0.0)
                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        end,
                    })
                end
            end)
        end
    end)
end

RedFW.Shared.Event:registerEvent("loadLocation", function()
    menu()
end)