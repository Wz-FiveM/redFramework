---log
---@param string
---@public
function RedFW.Shared.Event:log(string)
    print(("%s %s^7"):format(RedFW.Default.Prefix, string))
end
