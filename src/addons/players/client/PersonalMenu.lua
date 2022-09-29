local mainMenu = RageUI.CreateMenu("Inventory", "Inventory", 0, 80)
local active = false
mainMenu.Closed = function()
    active = false
end

local function menu()
    if (active) then
        return
    end
    active = true
    RageUI.Visible(mainMenu, true)
    Citizen.CreateThread(function()
        while (active) do
            Citizen.Wait(0)

            RageUI.IsVisible(mainMenu, function()

                RageUI.Separator(RedFW.Client.Components.Player.inventory.dataWeight .. "/" .. RedFW.Default.Inventory.weight.. " kg")

                for key, value in pairs(RedFW.Client.Components.Player.inventory.data) do
                    RageUI.Button(value.label, ('Count : %i | Weight : %s /U'):format(value.count, value.weight), { RightLabel = "→→→" }, true, {})
                end

            end)
        end
    end)
end


Keys.Register('F5', 'F5', 'Open Personal Menu.', function()
    menu()
end)