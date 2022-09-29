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

                for key, value in pairs(RedFW.Client.Components.Player.inventory.data) do
                    print(value)
                end

            end)
        end
    end)
end


Keys.Register('F5', 'F5', 'Open Personal Menu.', function()
    menu()
end)