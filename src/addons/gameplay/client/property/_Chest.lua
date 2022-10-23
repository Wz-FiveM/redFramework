local _PropertyChest = {}

RedFW.Shared.Event:registerEvent('receivePropertyChest', function(id, data)
    _PropertyChest[id] = data
end)

local active = false

local mainMenu <const> = RageUI.CreateMenu("Main", "Main Menu")
mainMenu.Closed = function()
    active = false
end

function ShowPropertyChest(nameOfProperty, id)
    if (active) then
        return
    end
    active = true
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
        while (active) do
            RageUI.IsVisible(mainMenu, function()
                RageUI.Separator("↓ ~b~Items dans le coffre ~s~↓")
                for item, value in pairs(_PropertyChest[id]) do
                    RageUI.Button(value.label, ('Count : %i'):format(value.count), { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            RedFW.Shared.Event:triggerServerEvent('privateInventory:interact', {
                                action = 'remove',
                                nameItem = item,
                                label = value.label,
                                count = RedFW.Client.Functions:KeyboardInput("Combien d'item voulez-vous retirer ?", "", 3),
                                name = nameOfProperty,
                                id = id
                            })
                        end
                    })
                end
                RageUI.Separator("↓ ~b~Items dans votre inventaire ~s~↓")
                for item, value in pairs(RedFW.Client.Components.Player.inventory.data) do
                    RageUI.Button(value.label, ('Count : %i | Weight : %s /U'):format(value.count, value.weight), { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            RedFW.Shared.Event:triggerServerEvent('privateInventory:interact', {
                                action = 'add',
                                nameItem = item,
                                label = value.label,
                                count = RedFW.Client.Functions:KeyboardInput("Combien d'item voulez-vous ajouter ?", "", 3),
                                name = nameOfProperty,
                                id = id
                            })
                        end
                    })
                end
            end)
            Wait(0)
        end
    end)
end