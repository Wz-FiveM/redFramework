local active = false
local main = RageUI.CreateMenu("Garage", "Garage")
main.Closed = function()
    active = false
end

local function openGarage(spawnPosition, spawnHeading)
    if not active then
        active = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while active do
                RageUI.IsVisible(main, function()
                    for key, value in pairs(RedFW.Client.Components.Vehicle:getAll()) do
                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(value.props.model)) .. " [".. value.plate.."]", nil, {RightLabel = "→→→"}, value.situation == "garagepublic", {
                            onSelected = function()
                                local vehicle = RedFW.Client.Functions:spawnVehicle(value.props.model, spawnPosition, spawnHeading)
                                RedFW.Client.Functions:SetVehicleProperties(vehicle, value.props)
                                RedFW.Client.Components.Vehicle:changeSituation(value.id, "out")
                                SetVehicleNumberPlateText(vehicle, value.plate)
                            end
                        })
                    end
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        RageUI.Line()
                        RageUI.Button("Ranger le véhicule", nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                local props = RedFW.Client.Functions:getVehicleProperties(vehicle)
                                local model = RedFW.Client.Components.Vehicle:getByPlate(props.plate)
                                RedFW.Client.Components.Vehicle:changeSituation(model.id, "garagepublic", props)
                                RedFW.Client.Functions:deleteCurrentVehicle(vehicle)
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("openGarage", function(spawnPosition, spawnHeading)
    openGarage(spawnPosition, spawnHeading)
end)
