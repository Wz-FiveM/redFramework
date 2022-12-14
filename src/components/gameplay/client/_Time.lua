---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Time.lua] created at [12/10/2022 21:03]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

RedFW.Shared.Event:registerEvent('setTime', function(hours, minutes)
    NetworkOverrideClockTime(hours, minutes, 0)
    print("^8Time set to " .. hours .. ":" .. minutes .. "^0")
end)