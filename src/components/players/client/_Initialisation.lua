---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Initialisation.lua] created at [25/09/2022 11:03]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Client.Components.Player = {}
RedFW.Client.Components.Player.inventory = {}
RedFW.Client.Components.Player.account = {}

CreateThread(function()
    DoScreenFadeOut(1000)
    print("^2Loading character...")
    while not NetworkIsSessionStarted() do
        Wait(1)
    end
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    FreezeEntityPosition(PlayerPedId(), false)
    RedFW.Client.Functions:requestModel(GetHashKey("mp_m_freemode_01"))
    SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
    SetPedDefaultComponentVariation(PlayerPedId())
    SetMaxWantedLevel(0)
    RedFW.Shared.Event:triggerServerEvent("onPlayerLoaded")
    Wait(1000)
    RedFW.Shared.Event:triggerServerEvent("getInventory")
    RedFW.Shared.Event:triggerServerEvent("getJob")
    RedFW.Shared.Event:triggerServerEvent("getAccounts")
    print("^2Loading complete...")
    DoScreenFadeIn(1000)
end)