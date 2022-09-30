---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Event.lua] created at [25/09/2022 11:04]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]


---triggerEvent
---@param nameEvent string
---@public
function RedFW.Shared.Event:triggerEvent(nameEvent, ...)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    TriggerEvent(newEvent, ...)
end

---registerEvent
---@param nameEvent string
---@param callback function
---@public
function RedFW.Shared.Event:registerEvent(nameEvent, callback)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    RegisterNetEvent(newEvent, callback)
end

---triggerServerEvent
---@param nameEvent string
---@public
function RedFW.Shared.Event:triggerServerEvent(nameEvent, ...)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    TriggerServerEvent(newEvent, ...)
end

---triggerClientEvent
---@param nameEvent string
---@param source number
---@public
function RedFW.Shared.Event:triggerClientEvent(nameEvent, source, ...)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    TriggerClientEvent(newEvent, source, ...)
end

---removeHandler
---@param nameEvent string
---@public
function RedFW.Shared.Event:removeHandler(nameEvent)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    RemoveEventHandler(newEvent)
end

---removeEvent
---@param nameEvent string
---@public
function RedFW.Shared.Event:removeEvent(nameEvent)
    RemoveEventHandler(nameEvent)
end

---handleEvent
---@param nameEvent string
---@public
function RedFW.Shared.Event:handleEvent(nameEvent, callback)
    local newEvent = "RedFW:"..GetHashKey(nameEvent)
    return AddEventHandler(newEvent, callback)
end