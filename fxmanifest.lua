---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [fxmanifest.lua] created at [25/09/2022 11:00]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

fx_version "adamant"
game "gta5"
lua54 "yes"

shared_scripts {
    "config.lua",
    "src/constant/shared/*.lua",
    "src/components/**/shared/*.lua",
    "src/addons/**/shared/**/*.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "src/components/**/server/*.lua",
    "src/constant/server/*.lua",
    "src/addons/**/server/**/*.lua",
}

client_scripts {
    --[[
        IPL
    ]]
    "src/vendors/Bob74/lib/**/*.lua",
    "src/vendors/Bob74/client.lua",
    "src/vendors/Bob74/**/*.lua",
    --[[
        RageUI
    ]]--
    "src/vendors/RageUI/RMenu.lua",
    "src/vendors/RageUI/menu/RageUI.lua",
    "src/vendors/RageUI/menu/Menu.lua",
    "src/vendors/RageUI/menu/MenuController.lua",
    "src/vendors/RageUI/components/*.lua",
    "src/vendors/RageUI/menu/elements/*.lua",
    "src/vendors/RageUI/menu/items/*.lua",
    "src/vendors/RageUI/menu/panels/*.lua",
    "src/vendors/RageUI/menu/windows/*.lua",
    --[[
        RedFramework
    ]]--
    "src/components/**/client/*.lua",
    "src/constant/client/*.lua",
    "src/addons/**/client/**/*.lua",
}