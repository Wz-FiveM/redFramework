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

---spawnVehicle
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

function RedFW.Client.Functions:SetScaleformParams(scaleform, data) -- Set des éléments dans un scalform
    data = data or {}
    for k,v in pairs(data) do
        PushScaleformMovieFunction(scaleform, v.name)
        if v.param then
            for _,par in pairs(v.param) do
                if math.type(par) == "integer" then
                    PushScaleformMovieFunctionParameterInt(par)
                elseif type(par) == "boolean" then
                    PushScaleformMovieFunctionParameterBool(par)
                elseif math.type(par) == "float" then
                    PushScaleformMovieFunctionParameterFloat(par)
                elseif type(par) == "string" then
                    PushScaleformMovieFunctionParameterString(par)
                end
            end
        end
        if v.func then v.func() end
        PopScaleformMovieFunctionVoid()
    end
end

function RedFW.Client.Functions:CreateScaleform(name, data) -- Créer un scalform
    if not name or string.len(name) <= 0 then return end
    local scaleform = RequestScaleformMovie(name)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    RedFW.Client.Functions:SetScaleformParams(scaleform, data)
    return scaleform
end

---getProperties
---@param vehicleId number
---@return table
---@public
function RedFW.Client.Functions:getVehicleProperties(vehicleId)
    if (not DoesEntityExist(vehicleId)) then
        return (error("Can't get vehicle properties for the vehicle (entity doesn't exist)"))
    end

    ---@type table
    local primaryColor, secondaryColor = GetVehicleColours(vehicleId)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicleId)
    local modLivery
    local extras, neons = {}, {}
    local numberWindows, doors, neonCount = 0, 0, 0
    local vehicleDamage = {
        windows = {},
        doors = {},
        tyres = {},
    }

    if GetIsVehiclePrimaryColourCustom(vehicleId) then primaryColor = {GetVehicleCustomPrimaryColour(vehicleId)} end

    if GetIsVehicleSecondaryColourCustom(vehicleId) then secondaryColor = {GetVehicleCustomSecondaryColour(vehicleId)} end

    for extraId = 1, 15 do
        if DoesExtraExist(vehicleId, extraId) then
            local state = IsVehicleExtraTurnedOn(vehicleId, extraId) == 1
            extras[tostring(extraId)] = state
        end
    end

    if GetVehicleMod(vehicleId, 48) == -1 and GetVehicleLivery(vehicleId) ~= -1 then
        modLivery = GetVehicleLivery(vehicleId)
    else
        modLivery = GetVehicleMod(vehicleId, 48)
    end

    for i = 0, 7 do
        if not IsVehicleWindowIntact(vehicleId, i) then
            numberWindows = numberWindows + 1
            vehicleDamage.windows[numberWindows] = i
        end
    end

    for i = 0, 5 do
        if IsVehicleDoorDamaged(vehicleId, i) then
            doors = doors + 1
            vehicleDamage.doors[doors] = i
        end
    end

    for i = 0, 5 do
        if IsVehicleTyreBurst(vehicleId, i, false) then
            vehicleDamage.tyres[i] = IsVehicleTyreBurst(vehicleId, i, true) and 2 or 1
        end
    end

    for i = 0, 3 do
        if IsVehicleNeonLightEnabled(vehicleId, i) then
            neonCount = neonCount + 1
            neons[neonCount] = i
        end
    end

    return {
        model = GetEntityModel(vehicleId),
        plate = GetVehicleNumberPlateText(vehicleId),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicleId),
        bodyHealth = math.floor(GetVehicleBodyHealth(vehicleId) + 0.5),
        engineHealth = math.floor(GetVehicleEngineHealth(vehicleId) + 0.5),
        tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicleId) + 0.5),
        fuelLevel = math.floor(GetVehicleFuelLevel(vehicleId) + 0.5),
        dirtLevel = math.floor(GetVehicleDirtLevel(vehicleId) + 0.5),
        color1 = primaryColor,
        color2 = secondaryColor,
        pearlescentColor = pearlescentColor,
        interiorColor = GetVehicleInteriorColor(vehicleId),
        dashboardColor = GetVehicleDashboardColour(vehicleId),
        wheelColor = wheelColor,
        wheels = GetVehicleWheelType(vehicleId),
        windowTint = GetVehicleWindowTint(vehicleId),
        xenonColor = GetVehicleXenonLightsColour(vehicleId),
        neonEnabled = neons,
        neonColor = table.pack(GetVehicleNeonLightsColour(vehicleId)),
        extras = extras,
        tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicleId)),
        modSpoilers = GetVehicleMod(vehicleId, 0),
        modFrontBumper = GetVehicleMod(vehicleId, 1),
        modRearBumper = GetVehicleMod(vehicleId, 2),
        modSideSkirt = GetVehicleMod(vehicleId, 3),
        modExhaust = GetVehicleMod(vehicleId, 4),
        modFrame = GetVehicleMod(vehicleId, 5),
        modGrille = GetVehicleMod(vehicleId, 6),
        modHood = GetVehicleMod(vehicleId, 7),
        modFender = GetVehicleMod(vehicleId, 8),
        modRightFender = GetVehicleMod(vehicleId, 9),
        modRoof = GetVehicleMod(vehicleId, 10),
        modEngine = GetVehicleMod(vehicleId, 11),
        modBrakes = GetVehicleMod(vehicleId, 12),
        modTransmission = GetVehicleMod(vehicleId, 13),
        modHorns = GetVehicleMod(vehicleId, 14),
        modSuspension = GetVehicleMod(vehicleId, 15),
        modArmor = GetVehicleMod(vehicleId, 16),
        modNitrous = GetVehicleMod(vehicleId, 17),
        modTurbo = IsToggleModOn(vehicleId, 18),
        modSubwoofer = GetVehicleMod(vehicleId, 19),
        modSmokeEnabled = IsToggleModOn(vehicleId, 20),
        modHydraulics = IsToggleModOn(vehicleId, 21),
        modXenon = IsToggleModOn(vehicleId, 22),
        modFrontWheels = GetVehicleMod(vehicleId, 23),
        modBackWheels = GetVehicleMod(vehicleId, 24),
        modCustomTiresF = GetVehicleModVariation(vehicleId, 23),
        modCustomTiresR = GetVehicleModVariation(vehicleId, 24),
        modPlateHolder = GetVehicleMod(vehicleId, 25),
        modVanityPlate = GetVehicleMod(vehicleId, 26),
        modTrimA = GetVehicleMod(vehicleId, 27),
        modOrnaments = GetVehicleMod(vehicleId, 28),
        modDashboard = GetVehicleMod(vehicleId, 29),
        modDial = GetVehicleMod(vehicleId, 30),
        modDoorSpeaker = GetVehicleMod(vehicleId, 31),
        modSeats = GetVehicleMod(vehicleId, 32),
        modSteeringWheel = GetVehicleMod(vehicleId, 33),
        modShifterLeavers = GetVehicleMod(vehicleId, 34),
        modAPlate = GetVehicleMod(vehicleId, 35),
        modSpeakers = GetVehicleMod(vehicleId, 36),
        modTrunk = GetVehicleMod(vehicleId, 37),
        modHydrolic = GetVehicleMod(vehicleId, 38),
        modEngineBlock = GetVehicleMod(vehicleId, 39),
        modAirFilter = GetVehicleMod(vehicleId, 40),
        modStruts = GetVehicleMod(vehicleId, 41),
        modArchCover = GetVehicleMod(vehicleId, 42),
        modAerials = GetVehicleMod(vehicleId, 43),
        modTrimB = GetVehicleMod(vehicleId, 44),
        modTank = GetVehicleMod(vehicleId, 45),
        modWindows = GetVehicleMod(vehicleId, 46),
        modDoorR = GetVehicleMod(vehicleId, 47),
        modLivery = modLivery,
        modLightbar = GetVehicleMod(vehicleId, 49),
        windows = vehicleDamage.windows,
        doors = vehicleDamage.doors,
        tyres = vehicleDamage.tyres,
        leftHeadlight = vehicleDamage.leftHeadlight,
        rightHeadlight = vehicleDamage.rightHeadlight,
        frontBumper = vehicleDamage.frontBumper,
        rearBumper = vehicleDamage.rearBumper,
    }
end

function RedFW.Client.Functions:SetVehicleProperties(vehicle, props)
    if DoesEntityExist(vehicle) then
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)

        if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
        if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
        if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
        if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
        if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
        if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
        if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
        if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
        if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
        if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
        if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
        if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end

        if props.extras then
            for extraId,enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(extraId), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(extraId), 1)
                end
            end
        end

        if props.colorInterior then
            SetVehicleInteriorColour(vehicle, props.colorInterior)
        end

        if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
        if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
        if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
        if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
        if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
        if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
        if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
        if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
        if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
        if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
        if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
        if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
        if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
        if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
        if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
        if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
        if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
        if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
        if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
        if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
        if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
        if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
        if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
        if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
        if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
        if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
        if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
        if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
        if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
        if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
        if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
        if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
        if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
        if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
        if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
        if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
        if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
        if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
        if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
        if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
        if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
        if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
        if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
        if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
        if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
        if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
        if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
    end
end

---getClosestPlayer
---@return number number number
---@public
function RedFW.Client.Functions:getClosestPlayer()
    local playerClosestPosition, playerClosestDistance
    ---@type any
    local playerClosest
    local players, coords = GetActivePlayers(), GetEntityCoords(PlayerPedId())
    for _, v in pairs(players) do
        if (GetPlayerPed(v) ~= PlayerPedId()) then
            local oPed = GetPlayerPed(v)
            ---@type any
            local oCoords = GetEntityCoords(oPed)
            local dst = #(oCoords - coords)
            if not (playerClosest) then
                playerClosest = v
                playerClosestPosition = oCoords
                playerClosestDistance = dst
            else
                if (dst < playerClosestDistance) then
                    playerClosest = v
                    playerClosestPosition = oCoords
                    playerClosestDistance = dst
                end
            end
        end
    end
    return (playerClosest), (playerClosestDistance)
end