RedFW.Server.Addons = {}
RedFW.Server.Addons.Property = {}
RedFW.Server.Addons.Property.__index = RedFW.Server.Addons.Property
RedFW.Server.Addons.Property.list = {}

setmetatable(RedFW.Server.Addons.Property, {
    __call = function(_, name, data)
        local self = setmetatable({}, RedFW.Server.Addons.Property)
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
        self.owner = self.data.owner
        self.price = self.data.price
        self.save = function()
            MySQL.query('UPDATE property SET data = @data WHERE name = @name', {
                ['@data'] = json.encode(self.data),
                ['@name'] = self.name,
            })
        end
        RedFW.Server.Components.Zone:add(vector3(json.decode(self.positionOutside).x, json.decode(self.positionOutside).y, json.decode(self.positionOutside).z), function(source)
            RedFW.Shared.Event:triggerClientEvent("loadProperty", source, self)
        end)
        RedFW.Server.Addons.Property.list[name] = self
        return self
    end
})

function RedFW.Server.Addons.Property:create(name)
    if not RedFW.Server.Addons.Property.list[name] then
        RedFW.Server.Addons.Property(name, {})
        MySQL.insert("property", {name = name, data = json.encode({})})
    end
end

function RedFW.Server.Addons.Property:get(name)
    return RedFW.Server.Addons.Property.list[name]
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
        chest = {}
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
            RedFW.Server.Addons.Property:get(data.name):addItem(data.nameItem, data.count)
        end
    elseif data.action == "remove" then
        local canRemove = RedFW.Server.Addons.Property:get(data.name):removeItem(data.nameItem, tonumber(data.count))
        if canRemove then
            player.inventory:addItem(data.nameItem, data.count)
        end
    end
end)

RedFW.Shared.Event:registerEvent('property:chest', function(name)
    local property = RedFW.Server.Addons.Property:get(name)
    if property then
        RedFW.Shared.Event:triggerClientEvent("receivePropertyChest", source, name, property.chest)
    end
end)