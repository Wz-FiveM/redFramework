---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Initialisation.lua] created at [25/09/2022 11:03]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Client.Components.Player = {}

CreateThread(function()
    DoScreenFadeOut(1000)
    print("Loading character...")
    while not NetworkIsSessionStarted() do
        Wait(1)
    end
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    FreezeEntityPosition(PlayerPedId(), false)
    RedFW.Shared.Event:triggerServerEvent("onPlayerLoaded")
    print("Loading complete...")
    DoScreenFadeIn(1000)
end)