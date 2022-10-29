RedFW.Server.Addons = {}
RedFW.Server.Addons.Property = {}
RedFW.Server.Addons.Property.__index = RedFW.Server.Addons.Property
RedFW.Server.Addons.Property.list = {}

setmetatable(RedFW.Server.Addons.Property, {
    __call = function(_, name, data)
        local self = setmetatable({}, RedFW.Server.Addons.Property)
        self.id = #RedFW.Server.Addons.Property.list + 1
        self.name = name
        self.data = data
        self.chest = data.chest
        self.positionOutside = self.data.positionOutside
        self.positionInside = self.data.positionInside
        self.chestPosition = self.data.chestPosition
        if data.positionOutsideGarage ~= "" then
            self.positionOutsideGarage = self.data.positionOutsideGarage
            self.positionInsideGarage = self.data.positionInsideGarage
            self.places = self.data.places
            RedFW.Server.Components.Zone:add(vector3(json.decode(self.positionOutsideGarage).x, json.decode(self.positionOutsideGarage).y, json.decode(self.positionOutsideGarage).z), function(source)
                RedFW.Shared.Event:triggerClientEvent("loadProperty", source, self)
            end)
        end
        if self.data.owner == nil then
            self.owner = "vide"
        else
            self.owner = self.data.owner
        end
        self.price = self.data.price

        ---@param self table
        self.save = function()
            MySQL.query('UPDATE property SET data = @data WHERE name = @name', {
                ['@data'] = json.encode(self.data),
                ['@name'] = self.name,
            })
        end
        RedFW.Server.Components.Zone:add(vector3(json.decode(self.positionOutside).x, json.decode(self.positionOutside).y, json.decode(self.positionOutside).z), function(source)
            if self.owner == RedFW.Server.Components.Players:get(source).identifier then
                RedFW.Shared.Event:triggerClientEvent("loadProperty", source, self)
            elseif self.owner == "vide" then
                RedFW.Shared.Event:triggerClientEvent("receiveNotification", source, "Vous pouvez acheter cette propriété pour "..self.price.."$")
            else
                RedFW.Shared.Event:triggerClientEvent("receiveNotification", source, "Cette propriété est déjà achetée")
            end
        end)
        RedFW.Server.Addons.Property.list[self.id] = self
        return self
    end
})

function RedFW.Server.Addons.Property:create(name)
    if not RedFW.Server.Addons.Property.list[#RedFW.Server.Addons.Property.list + 1] then
        RedFW.Server.Addons.Property(name, {})
        MySQL.insert("property", {name = name, data = json.encode({})})
    end
end

function RedFW.Server.Addons.Property:get(id)
    return RedFW.Server.Addons.Property.list[id]
end

RedFW.Server.Components.Callback:register("getProperty", function()
    return RedFW.Server.Addons.Property.list
end)

RedFW.Shared.Event:registerEvent("property:build", function(name, pPos, posInProperty, pPosGarage, posInGarage, places, price, posChest)
    local data = {
        positionOutside = pPos,
        positionInside = posInProperty,
        positionOutsideGarage = pPosGarage,
        positionInsideGarage = posInGarage,
        chestPosition = posChest,
        places = places,
        price = price,
        chest = {},
        owner = "vide"
    }
    MySQL.Async.execute("INSERT INTO property (name, data) VALUES (@name, @data)", {
        ["@name"] = name,
        ["@data"] = json.encode(data)
    }, function()
        RedFW.Server.Addons.Property(name, data)
    end)
end)

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM property", {}, function(result)
        for _, v in pairs(result) do
            RedFW.Server.Addons.Property(v.name, json.decode(v.data))
            print("^2Property " .. v.name .. " loaded^0")
        end
    end)
end)

function RedFW.Server.Addons.Property:getChest()
    return self.chest
end

---@param item string
---@param count number
function RedFW.Server.Addons.Property:addItem(item, count)
    if not self.chest[item] then
        self.chest[item] = {
            count = count,
            label = RedFW.Server.Components.Players.items:get(item).getLabel(),
        }
    else
        self.chest[item].count = self.chest[item].count + count
    end
    self.save()
    RedFW.Shared.Event:triggerClientEvent("receivePropertyChest", -1, self.name, self.chest)
end

---@param item string
---@param count number
function RedFW.Server.Addons.Property:removeItem(item, count)
    if self.chest[item] then
        if self.chest[item].count >= count then
            self.chest[item].count = self.chest[item].count - count
            if self.chest[item].count == 0 then
                self.chest[item] = nil
            end
            self.save()
            RedFW.Shared.Event:triggerClientEvent("receivePropertyChest", -1, self.name, self.chest)
            return true
        end
    end
end

RedFW.Shared.Event:registerEvent('privateInventory:interact', function(data)
    local _src = source
    local player = RedFW.Server.Components.Players:get(_src)
    if data.action == "add" then
        local canAdd = player.inventory:removeItem(data.nameItem, data.count)
        if canAdd then
            RedFW.Server.Addons.Property:get(data.id):addItem(data.nameItem, data.count)
        end
    elseif data.action == "remove" then
        local canRemove = RedFW.Server.Addons.Property:get(data.id):removeItem(data.nameItem, tonumber(data.count))
        if canRemove then
            player.inventory:addItem(data.nameItem, data.count)
        end
    end
end)

RedFW.Shared.Event:registerEvent('property:chest', function(id)
    local property = RedFW.Server.Addons.Property:get(id)
    if property then
        RedFW.Shared.Event:triggerClientEvent("receivePropertyChest", source, id, property.chest)
    end
end)

RedFW.Shared.Event:registerEvent("property:give", function(_src, id, price)
    local player = RedFW.Server.Components.Players:get(_src)
    if player.account:get().cash >= price then
        player.account:removeCash(price)
        player.save()
        local property = RedFW.Server.Addons.Property:get(id)
        property.data.owner = player.identifier
        property.owner = player.identifier
        property.save()
        RedFW.Shared.Event:triggerClientEvent("receiveNotification", _src, "Vous avez acheté la propriété "..id.." pour "..price.."$")
        RedFW.Shared.Event:triggerClientEvent("receiveNotification", _src, "Vous pouvez maintenant y accéder")
    else
        RedFW.Shared.Event:triggerClientEvent("receiveNotification", _src, "Vous n'avez pas assez d'argent")
    end
end)