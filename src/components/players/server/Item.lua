RedFW.Server.Components.Players.items = {}
RedFW.Server.Components.Players.items.list = {}

---exist
---@param item string
---@return boolean
---@public
function RedFW.Server.Components.Players.items:exist(item)
    if (RedFW.Server.Components.Players.items.list[item]) then
        return true
    end
    return false
end

---registerItem
---@param item table
---@return void
---@public
function RedFW.Server.Components.Players.items:registerItem(item)
    if (not RedFW.Server.Components.Players.items:exist(item.name)) then
        RedFW.Server.Components.Players.items.list[item.name] = item
        print(('^2Item %s registered^0'):format(item.name))
    else
        print(('^1Item %s already exist^0'):format(item.name))
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