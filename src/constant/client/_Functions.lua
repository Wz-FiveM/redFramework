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