---@author Wezor.
--[[

  This file is part of Wezor Project.

  File [fxmanifest.lua] created at [25/09/2022 11:00]
  Copyright (c) Wezor - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.

--]]

fx_version "adamant"
game "rdr3"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
lua54 "yes"

shared_scripts {
    "config.lua",
    "src/constant/shared/*.lua",
    "src/components/**/shared/*.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "src/constant/server/*.lua",
    "src/components/**/server/*.lua",
}

client_scripts {
    "src/constant/client/*.lua",
    "src/components/**/client/*.lua",
}