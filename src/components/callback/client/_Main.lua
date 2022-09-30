RedFW.Client.Components.Callback = {}

---triggerServer
---@param eventName string
---@param cb function
---@public
function RedFW.Client.Components.Callback:triggerServer(eventName, cb, ...)
  local ticket <const> = ("__callback:%s:%s"):format("RedFW:"..GetHashKey(eventName), GetNetworkTime())

  local p <const> = promise.new()

  RedFW.Shared.Event:registerEvent(ticket)
  local handler <const> = RedFW.Shared.Event:handleEvent(ticket, function(...)
    p:resolve({...})
  end)

  RedFW.Shared.Event:triggerServerEvent("callback:server", eventName, ticket, ...)

  local result <const> = Citizen.Await(p)
  RedFW.Shared.Event:removeEvent(handler)
  
  cb(table.unpack(result))
end

---triggerServerAsync
---@param eventName string
---@return any
---@public
function RedFW.Client.Components.Callback:triggerServerAsync(eventName, ...)
  local p <const> = promise.new()

  RedFW.Client.Components.Callback:triggerServer(eventName, function(...)
    p:resolve({...})
  end, ...)

  return table.unpack(Citizen.Await(p))
end