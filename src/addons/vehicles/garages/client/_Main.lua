local active = false
local main = RageUI.CreateMenu("Garage", "Garage")
main.Closed = function()
    active = false
end

local function openGarage()
    if not active then
        active = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while active do
                RageUI.IsVisible(main, function()
                    for key, value in pairs(RedFW.Client.Components.Vehicle:getAll()) do
                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(value.props.model)), nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("openGarage", function()
    openGarage()
end)
