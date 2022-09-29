RedFW.Client.Components.Player.inventory = {}

RedFW.Shared.Event:registerEvent("receiveInventory", function(data, dataWeight)
    print(json.encode(data))
    RedFW.Client.Components.Player.inventory.data = data
    RedFW.Client.Components.Player.inventory.dataWeight = dataWeight
end)

