RedFW.Shared.Event:registerEvent("receiveInventory", function(data, dataWeight)
    RedFW.Client.Components.Player.inventory.data = data.inventory
    print(json.encode(data.inventory))
    RedFW.Client.Components.Player.inventory.dataWeight = dataWeight
end)