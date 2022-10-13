---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [UIInfo.lua] created at [17/09/2022 16:30]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

---Info
---@param Info string
---@param RightText string
---@param LeftText string
---@return nil
function RageUI.Info(Title, RightText, CenterText, LeftText, useCadre)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText(Title .. "~h~", 350 + 20 + 250, 200, 4, 0.44, 255, 255, 255, 255, 0, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 338 + 20 + 150, Title ~= nil and 230 or 7, 4, 0.36, 255, 255, 255, 255, 0)
    end
    if CenterText ~= nil then
        RenderText(table.concat(CenterText, "\n"), 338 + 20 + 280, Title ~= nil and 230 or 7, 4, 0.36, 255, 255, 255, 255)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 338 + 332 + 150, Title ~= nil and 230 or 7, 4, 0.36, 255, 255, 255, 255, 2)
    end
    RenderRectangle(332 + 10 + 150, 200, 5, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 255)
    RenderRectangle(332 + 10 + 150, 200, 332, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
    if useCadre then
        RenderRectangle(820, 80, 5, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 255)
        RenderRectangle(332 + 10 + 150, 80, 332, 5, 0, 0, 0, 160)
        RenderRectangle(332 + 10 + 150, 145, 332, 5, 0, 0, 0, 160)
    end
end