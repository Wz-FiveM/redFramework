local serverCallbacks <const> = {}

RedFW.Server.Components.Callback = {}

---register
---@param eventName string
---@param cb function
---@public
function RedFW.Server.Components.Callback:register(eventName, cb)
  if (type(eventName) ~= "string") then
    return error(("eventName expected string, but got %s"):format(type(eventName)), 1)
  end

  if (type(cb) ~= "function") then 
    return error(("cb name expected string, but got %s"):format(type(eventName)), 1)
  end

  if (serverCallbacks[eventName]) then 
    print(("Server callback override, eventName: %s"):format(eventName), 2)
  end

  serverCallbacks[eventName] = cb
  print(("^2New server callback registered. eventName:^0 ^3%s^0"):format(eventName), 3)
end

RedFW.Shared.Event:registerEvent("callback:server", function(eventName, ticket, ...)
    if (not serverCallbacks[eventName]) then 
      return error(("server callback not registered! eventName: %s"):format(type(eventName)), 1)
    end
  
    local result <const> = { serverCallbacks[eventName](source, ...) }
  
    RedFW.Shared.Event:triggerClientEvent(ticket, source, table.unpack(result))
  end)