RedFW.Server.Components.Zone = {}
RedFW.Server.Components.Zone.list = {}
RedFW.Server.Components.Zone.__index = RedFW.Server.Components.Zone

setmetatable(RedFW.Server.Components.Zone, {
    __call = function (_, position, action, job)
        local self = setmetatable({}, RedFW.Server.Components.Zone)
        self.position = position
        self.action = action
        self.job = job
        self.id = #RedFW.Server.Components.Zone.list + 1
        RedFW.Server.Components.Zone.list[self.id] = self
        RedFW.Shared.Event:triggerClientEvent("loadZone", -1, RedFW.Server.Components.Zone.list)
        return self
    end
})

---add
---@param position Vector3
---@param action function
---@param job string
---@return void
---@public
function RedFW.Server.Components.Zone:add(position, action, job)
    return RedFW.Server.Components.Zone(position, action, job)
end

---get 
---@param id number
---@return table
---@public
function RedFW.Server.Components.Zone:get(id)
    return RedFW.Server.Components.Zone.list[id]
end

RedFW.Shared.Event:registerEvent("zoneAction", function(id)
    local _src = source
    local zone = RedFW.Server.Components.Zone:get(id)
    if zone then
        zone.action(_src)
    end
end)

RedFW.Shared.Event:registerEvent("loadZone", function()
    local _src = source
    RedFW.Shared.Event:triggerClientEvent("loadZone", _src, RedFW.Server.Components.Zone.list)
end)

RegisterCommand("pos", function(source, args)
    local pos = GetEntityCoords(GetPlayerPed(source))
    print(pos)
end)