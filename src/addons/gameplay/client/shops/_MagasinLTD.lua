---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_MagasinLTD.lua] created at [22/10/2022 10:45]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

local mainOrder = {}
local active = false
local main = RageUI.CreateMenu("Magasin", "Magasin")
main.Closed = function()
    active = false
end

local function OpenWaterMenu()
    if not active then
        active = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while active do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(MagasinLTD) do
                        for _, item in pairs(MagasinLTD[k].itemsWater) do
                            RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."$"}, true, {
                                onSelected = function()
                                    if mainOrder[item.name] then
                                        mainOrder[item.name].quantity = mainOrder[item.name].quantity + 1
                                    else
                                        mainOrder[item.name] = {
                                            quantity = 1,
                                            price = item.price,
                                            label = item.label,
                                        }
                                    end
                                end,
                            })
                        end
                    end
                end)
                Wait(0)
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("loadLtdWater", function()
    OpenWaterMenu()
end)

local main2 = RageUI.CreateMenu("Magasin", "Magasin")
main2.Closed = function()
    active = false
end

local function OpenFoodMenu()
    if not active then
        active = true
        RageUI.Visible(main2, true)
        Citizen.CreateThread(function()
            while active do
                RageUI.IsVisible(main2, function()
                    for k, v in pairs(MagasinLTD) do
                        for _, item in pairs(MagasinLTD[k].itemsFood) do
                            RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."$"}, true, {
                                onSelected = function()
                                    if mainOrder[item.name] then
                                        mainOrder[item.name].quantity = mainOrder[item.name].quantity + 1
                                    else
                                        mainOrder[item.name] = {
                                            quantity = 1,
                                            price = item.price,
                                            label = item.label,
                                        }
                                    end
                                end,
                            })
                        end
                    end
                end)
                Wait(0)
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("loadLtdFood", function()
    OpenFoodMenu()
end)

local main3 = RageUI.CreateMenu("Magasin", "Magasin")
main3.Closed = function()
    active = false
end

local function OpenOrderMenu()
    if not active then
        active = true
        RageUI.Visible(main3, true)
        Citizen.CreateThread(function()
            while active do
                RageUI.IsVisible(main3, function()
                    for k, order in pairs(mainOrder) do
                        RageUI.Button(order.label, "Appuyer sur ENTRER pour réduire la quantité 1 par 1", {RightLabel = ('(x%s) %s$'):format(order.quantity, order.price * order.quantity)}, true, {
                            onSelected = function()
                                if order.quantity > 1 then
                                    order.quantity = order.quantity - 1
                                else
                                    mainOrder[k] = nil
                                end
                            end,
                        })
                    end
                    RageUI.Separator("↓ Confirmer votre commande ↓")
                    RageUI.Button("Confirmer", nil, {RightLabel = ">>"}, true, {
                        onSelected = function()
                            RedFW.Shared.Event:triggerServerEvent("buyLtdOrder", mainOrder)
                        end,
                    })
                end)
                Wait(0)
            end
        end)
    end
end

RedFW.Shared.Event:registerEvent("loadLtdOrder", function()
    OpenOrderMenu()
end)