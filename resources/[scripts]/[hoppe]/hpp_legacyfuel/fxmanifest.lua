fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"@_core/libs/utils.lua",
	"config.lua",
    'client.lua'
}

server_scripts {
	"@_core/libs/utils.lua",
	'server.lua'
}

ui_page "html/index.html"

files {
	"html/*"
}