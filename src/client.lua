exports('GetCoreObject', function()
    return RedFW
end)

AddEventHandler('GetCoreObject', function(cb)
    cb(RedFW)
  end)