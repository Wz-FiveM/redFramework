RedFW.Server.Components.Players.items = {}
RedFW.Server.Components.Players.items.list = {}

---exist
---@param item string
---@return boolean
---@public
function RedFW.Server.Components.Players.items:exist(item)
    return RedFW.Server.Components.Players.items.list[item] ~= nil
end

---registerItem
---@param item table
---@return void
---@public
function RedFW.Server.Components.Players.items:registerItem(item)
    if not RedFW.Server.Components.Players.items:exist(item) then
        RedFW.Server.Components.Players.items.list[item] = item
    else
        error("Item "..item.." already exist")
    end
end

---get
---@param itemName string
---@return table
---@public
function RedFW.Server.Components.Players.items:get(itemName)
    return RedFW.Server.Components.Players.items.list[itemName]
end

---getWeight
---@return number
---@public
function RedFW.Server.Components.Players.items:getWeight()
    return self.weight
end

---getLabel
---@return string
---@public
function RedFW.Server.Components.Players.items:getLabel()
    return self.label
end