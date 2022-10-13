RedFW.Client.Functions = {}

function RedFW.Client.Functions:requestModel(model)
    if not IsModelValid(model) then
        return false
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
    end
    return true
end

function RedFW.Client.Functions:notification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function RedFW.Client.Functions:notificationPicture(title, subtitle, message, iconType, iconId)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage(iconType, iconId, true, iconType, title, subtitle)
    DrawNotification(false, false)
end

---helpNotification
---@param message string
---@return void
---@public
function RedFW.Client.Functions:helpNotification(message)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

RedFW.Shared.Event:registerEvent("receiveNotification", function(message)
    RedFW.Client.Functions:notification(message)
end)

--- Spawn a vehicle
---@param model string
---@param coords table
---@param heading number
---@return vehicle 
---@public
function RedFW.Client.Functions:spawnVehicle(model, coords, heading)
    if not IsModelValid(model) then
        return false
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
    end
    local vehicle = CreateVehicle(model, coords, heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetModelAsNoLongerNeeded(model)
    return vehicle
end

function RedFW.Client.Functions:deleteCurrentVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetEntityAsMissionEntity(vehicle, false, false)
    if vehicle ~= nil then
        DeleteVehicle(vehicle)
    end
end

---KeyboardInput
---@param TextEntry string
---@param ExampleText string
---@param MaxInputLength number
---@return string
---@public
function RedFW.Client.Functions:KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end