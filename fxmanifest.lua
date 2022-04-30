fx_version 'adamant'
game 'gta5'

client_scripts {
	'dependencies/RageUI/RMenu.lua',
    'dependencies/RageUI/menu/RageUI.lua',
    'dependencies/RageUI/menu/Menu.lua',
    'dependencies/RageUI/menu/MenuController.lua',
    'dependencies/RageUI/components/*.lua',
    'dependencies/RageUI/menu/elements/*.lua',
    'dependencies/RageUI/menu/items/*.lua',
    'dependencies/RageUI/menu/panels/*.lua',
    'dependencies/RageUI/menu/windows/*.lua',

    'client/function.lua',
    'client/zones.lua',
    'client/richpresence.lua',
    'client/command.lua',
    'client/player/player.lua',
    'client/player/spawn.lua',
    'client/player/pickup.lua',

    'module/interaction/cl_interact.lua'
}

shared_scripts {
    'shared/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
    'server/player/*.lua',
    
    'module/interaction/sv_interact.lua'
}

exports {
    "GetPlayerInventoryItems",
    "GetPlayerInventoryWeight",
}