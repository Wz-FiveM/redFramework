---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [Skin.lua] created at [29/10/2022 11:27]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Server.Components.Callback:register("RedFW:Player:getSkin", function()
    local _src = source
    local player = RedFW.Server.Components.Player:get(_src)
    return player.skin
end)