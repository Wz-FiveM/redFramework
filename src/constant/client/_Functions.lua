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

function RedFW.Client.Functions:notificationPicture(message, title, subtitle, iconType, iconId)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage(iconType, iconId, true, iconType, title, subtitle)
    DrawNotification(false, false)
end

RedFW.Shared.Event:registerEvent("receiveNotification", function(message)
    RedFW.Client.Functions:notification(message)
end)