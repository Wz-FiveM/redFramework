RedFW.Server.Components.Rank = {}
RedFW.Server.Components.Rank.listRanks = {
    ["admin"] = {power = 100, label = "Administrateur"},
    ["user"] = {power = 0, label = "Utilisateur"}
}

---get
---@param rank string
---@return table
---@public
function RedFW.Server.Components.Rank:get(rank)
    return RedFW.Server.Components.Rank.listRanks[rank]
end

---getAll
---@return table
---@public 
function RedFW.Server.Components.Rank:getAll()
    return RedFW.Server.Components.Rank.listRanks
end

function RedFW.Server.Components.Rank:getPower()
    return self.power
end

function RedFW.Server.Components.Rank:canUseThisCommand(serverId, requirePower)
    local player = RedFW.Server.Components.Players:get(serverId)
    if player then
        local rank = RedFW.Server.Components.Rank:get(player.getRank())
        if rank then
            if rank.getPower() >= requirePower then
                return true
            else
                return false
            end
        end
    end
end