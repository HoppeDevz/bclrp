-- Resource Metadata
fx_version 'bodacious'
games { 'gta5' }

github "https://github.com/HoppeDevz?tab=repositories"
author 'HoppeDevz'

client_scripts {
    '@_core/libs/utils.lua',
    'config/cfg.lua',
    'client.lua'
}

server_scripts {
    '@_core/libs/utils.lua',
    'server.lua'
}

ui_page "html/index.html"

files {
    "html/*"
}

