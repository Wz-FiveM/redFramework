local active = false
local main = RageUI.CreateMenu("Garage", "Garage")
main.Closed = function()
    active = false
end

local function openGarage()
    if not active then
        active = true
        main:Display()
        RedFW.Client.Components.Callback:triggerServer("getVehicleList", function(vehicles)
            for k, v in pairs(vehicles) do
                RedFW.Client.Components.Player.vehicle.list[v.id] = v
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("openGarage", function()
    openGarage()
end)
