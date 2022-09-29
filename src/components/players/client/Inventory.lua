RedFW.Shared.Event:registerEvent("receiveInventory", function(data, dataWeight)
    RedFW.Client.Components.Player.inventory.data = data.data
    RedFW.Client.Components.Player.inventory.dataWeight = dataWeight
end)