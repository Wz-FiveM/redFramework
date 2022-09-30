RedFW.Server.Components.Players.rank = {}
RedFW.Server.Components.Players.rank.__index = RedFW.Server.Components.Players.rank
RedFW.Server.Components.Players.rank.availableRank = {
    ["user"] = {power = 0, label = "user"},
    ["moderator"] = {power = 1, label = "moderator"},
    ["admin"] = {power = 2, label = "administrator"},
    ["superadmin"] = {power = 3, label = "superadmin"},
    ["owner"] = {power = 4, label = "owner"}
}

CreateThread(function()
    for key, value in pairs(RedFW.Server.Components.Players.rank.availableRank) do
        local self = setmetatable({}, RedFW.Server.Components.Players.rank)
        self.rankName = key
        self.rankLabel = value.label
        self.powerIndex = value.power
        RedFW.Server.Components.Players.rank.availableRank[key] = self
        print("^2Rank " .. key .. " loaded^0")
    end
end)

function RedFW.Server.Components.Players.rank:getRank(rankName)
    if RedFW.Server.Components.Players.rank.availableRank[rankName] then
        return RedFW.Server.Components.Players.rank.availableRank[rankName]
    else
        return RedFW.Server.Components.Players.rank.availableRank["user"]
    end
end

function RedFW.Server.Components.Players.rank:canUseThisCommand(serverId, powerIndex)
    local player = RedFW.Server.Components.Players:get(serverId)
    if player.rank.powerIndex >= powerIndex then
        return true
    else
        return false
    end
end