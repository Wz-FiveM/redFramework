RedFW.Server.Components.Players.items = {}
RedFW.Server.Components.Players.items.list = {}

setmetatable(RedFW.Server.Components.Players.items, {
    __call = function(_, data)
        local self = setmetatable({}, RedFW.Server.Components.Players.items)
        self.data = data
        self.getLabel = function()
            return self.data.label
        end
        self.getWeight = function()
            return self.data.weight
        end
        RedFW.Server.Components.Players.items.list[self.data.name] = self
        return self
    end
})

---register
---@param data table
---@return void
---@public
function RedFW.Server.Components.Players.items:register(data)
    if data.name == nil then return end 
    if data.label == nil then return end
    if data.weight == nil then return end
    RedFW.Server.Components.Players.items(data)
end

---get
---@param name string
---@return table
---@public
function RedFW.Server.Components.Players.items:get(name)
    if RedFW.Server.Components.Players.items.list[name] == nil then print("^1Item : ("..name..") does not exist^0") return end
    return RedFW.Server.Components.Players.items.list[name]
end

---@return itemsList table
function RedFW.Server.Components.Players.items:getAll()
    return RedFW.Server.Components.Players.items.list
end

RedFW.Server.Components.Players.items:register({
    name = "water",
    label = "Water",
    weight = 0.5
})

RedFW.Server.Components.Players.items:register({
    name = "bread",
    label = "Bread",
    weight = 0.5
})


RedFW.Shared.Event:registerEvent("loadItem", function()
    RedFW.Shared.Event:triggerClientEvent("loadItem", source, RedFW.Server.Components.Players.items:getAll())
end)