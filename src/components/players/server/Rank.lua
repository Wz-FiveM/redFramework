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