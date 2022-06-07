fx_version 'adamant'

game 'gta5'

description 'Kmack710 - Management System'

version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', -- Comment out if not using ESX 
    'configs/config.lua',
    'configs/locales.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server.lua'
}

client_scripts {
    'data/client.lua'
}

lua54 'yes'