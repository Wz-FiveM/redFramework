---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [_Time.lua] created at [12/10/2022 21:03]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

local CurrentTime

CreateThread(function()
    local savedTime = RedFW.Server.Functions:file_read("resources/redFramework/src/constant/server/time.json")
    if savedTime then
        CurrentTime = json.decode(savedTime)
    end;
    while true do
        Wait(1000*60)
        if CurrentTime then
            CurrentTime.minute = CurrentTime.minute + 1
            if CurrentTime.minute == 60 then
                CurrentTime.minute = 0
                CurrentTime.hour = CurrentTime.hour + 1
                if CurrentTime.hour == 24 then
                    CurrentTime.hour = 0
                end;
            end;
            RedFW.Server.Functions:file_write("resources/redFramework/src/constant/server/time.json", json.encode(CurrentTime))
            RedFW.Shared.Event:triggerClientEvent("setTime", -1, CurrentTime.hour, CurrentTime.minute)
        end;
    end
end)