fx_version 'adamant'
game 'gta5'

client_scripts {
    'src/client/classes/*.lua',
    "src/dependencies/RageUI/RMenu.lua",
    "src/dependencies/RageUI/menu/RageUI.lua",
    "src/dependencies/RageUI/menu/Menu.lua",
    "src/dependencies/RageUI/menu/MenuController.lua",
    "src/dependencies/RageUI/components/*.lua",
    "src/dependencies/RageUI/menu/elements/*.lua",
    "src/dependencies/RageUI/menu/items/*.lua",
    "src/dependencies/RageUI/menu/panels/*.lua",
    "src/dependencies/RageUI/menu/windows/*.lua",
    'src/dependencies/map/client.lua',
    'src/client/utils/*.lua',
    'src/client/player/*.lua',
    'src/addons/interactMenu/client/*.lua'
}

shared_scripts {
    'src/shared/*.lua',
    "src/dependencies/map/shared.lua",
    'src/addons/../shared/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'src/dependencies/map/server.lua',
    'src/server/classes/*.lua',
    'src/server/player/*.lua',
    'src/addons/interactMenu/server/*.lua'
}