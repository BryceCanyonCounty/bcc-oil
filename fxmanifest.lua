game 'rdr3'
fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

author 'BCC @Jake2k4'

description 'This is an in depth Oil Job Script for RedM!'

shared_scripts {
    'configs/config.lua',
    'locale.lua',
    'languages/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/dbUpdater.lua',
    'server/server.lua'
}

client_scripts {
    'client/MainPedSpawns.lua',
    'client/OilMissions.lua',
    'client/SupplyMissions.lua',
    'client/MainWagonSpawn.lua',
    'client/MenuSetups.lua',
    'client/CriminalMissionsSetup.lua',
    'client/functions.lua'
}

version '1.3.0'

dependencies {
    'vorp_core',
    'vorp_inventory',
    'bcc-utils',
    'bcc-minigames',
    'vorp_progressbar',
    'feather-menu'
}
