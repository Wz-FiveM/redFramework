RedFW.Server.Components.Weather = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

local currentWeather

CreateThread(function()
    local savedWeather = RedFW.Server.Functions:file_read("resources/redFramework/src/constant/server/weather.txt")
    for key, value in pairs(RedFW.Server.Components.Weather) do
        if value == savedWeather then
            currentWeather = value
        end
    end
    while true do
        Wait(60000 * 5)
        local new = math.random(1, #RedFW.Server.Components.Weather)
        local newWeather 
        for key, value in pairs(RedFW.Server.Components.Weather) do
            if key == new then
                newWeather = value
            end
        end
        RedFW.Shared.Event:triggerClientEvent("setWeather", -1, newWeather)
        print("^8Weather set to " .. newWeather.."^0")
        RedFW.Server.Functions:file_write("resources/redFramework/src/constant/server/weather.txt", newWeather)
    end
end)

RedFW.Server.Components.Callback:register("getWeather", function()
    return currentWeather
end)