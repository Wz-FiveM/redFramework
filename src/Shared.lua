--[[exports('GetCoreObject', function()
  return RedFW
end)

AddEventHandler('GetCoreObject', function(cb)
  cb(RedFW)
end)]]--

RedFW_Exports = {}
--- Export Metatable
---@param superclass table
---@param class table
---@return table
function RedFW_Exports:exportMetatable(superclass, class)
  for name, v in pairs(superclass) do
    class[name] = function(o, ...)
      return (v(o, ...))
    end
  end
end

_G.RedFW.exports = RedFW_Exports

local function getCore()
  return (_G.RedFW)
end

--exports('GetCoreObject', getCore())

exports('GetCoreObject', function()
  return getCore()
end)