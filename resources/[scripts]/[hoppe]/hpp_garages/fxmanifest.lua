fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
	'drift.lua'
}

server_scripts {
	"@_core/libs/utils.lua",
	'server.lua'
}

files {
	"html/*"
}

ui_page "html/index.html"

