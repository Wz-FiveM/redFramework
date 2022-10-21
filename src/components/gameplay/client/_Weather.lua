local currentWeather = 0
RedFW.Shared.Event:registerEvent("setWeather", function(weather)
    SetWeatherTypeOverTime(currentWeather, 15.0)
    Citizen.Wait(15000)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
    currentWeather = weather
    print("^2Weather set to " .. weather.."^0")
    local allWeather = {
        ["EXTRASUNNY"] = "Grand soleil",
        ["CLEAR"] = "Petit soleil",
        ["CLOUDS"] = "Nuageux",
        ["SMOG"] = "Brumeux",
        ["FOGGY"] = "Brouillard",
        ["OVERCAST"] = "Couvert",
        ["CLEARING"] = "Grand soleil",
        ["THUNDER"] = "Orage",
        ["BLIZZARD"] = "Blizzard",
        ["SNOWLIGHT"] = "Neige",
        ["SNOW"] = "Neige",
        ["HAIL"] = "Grêle",
        ["SLEET"] = "Pluie verglaçante",
        ["DRIZZLE"] = "Bruine",
        ["RAIN"] = "Pluie",
        ["SHOWER"] = "Averse",
        ["XMAS"] = "Noël",
        ["HALLOWEEN"] = "Halloween"
    }
    RedFW.Client.Functions:notification("La météo est maintenant de type: "..allWeather[weather])
end)

CreateThread(function()
    RedFW.Client.Components.Callback:triggerServer('getWeather', function(weather)
        SetWeatherTypeOverTime(currentWeather, 15.0)
        Citizen.Wait(15000)
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
        currentWeather = weather
        print("^2Weather set to " .. weather.."^0")
        local allWeather = {
            ["EXTRASUNNY"] = "Grand soleil",
            ["CLEAR"] = "Petit soleil",
            ["CLOUDS"] = "Nuageux",
            ["SMOG"] = "Brumeux",
            ["FOGGY"] = "Brouillard",
            ["OVERCAST"] = "Couvert",
            ["CLEARING"] = "Grand soleil",
            ["THUNDER"] = "Orage",
            ["BLIZZARD"] = "Blizzard",
            ["SNOWLIGHT"] = "Neige",
            ["SNOW"] = "Neige",
            ["HAIL"] = "Grêle",
            ["SLEET"] = "Pluie verglaçante",
            ["DRIZZLE"] = "Bruine",
            ["RAIN"] = "Pluie",
            ["SHOWER"] = "Averse",
            ["XMAS"] = "Noël",
            ["HALLOWEEN"] = "Halloween"
        }
        RedFW.Client.Functions:notification("La météo est maintenant de type: "..allWeather[weather])
    end)
end)