RegisterCommand('admin', function(source, args)
    local canUse = RedFW.Server.Components.Players.rank:canUseThisCommand(source, 1)
    if canUse then
        RedFW.Shared.Event:triggerClientEvent('administration:openMenu', source)
    end
end)

RedFW.Server.Components.Callback:register("administration:getAllPlayers", function()
    return RedFW.Server.Components.Players:getAll()
end)