fx_version 'adamant'
game 'gta5'

client_scripts {
    'src/dependencies/map/client.lua',
    'src/client/classes/*.lua',
    'src/client/utils/*.lua',
    'src/client/player/*.lua',
}

shared_scripts {
    'src/shared/*.lua',
    "src/dependencies/map/shared.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'src/dependencies/map/server.lua',
    'src/server/classes/*.lua',
    'src/server/player/*.lua'
}