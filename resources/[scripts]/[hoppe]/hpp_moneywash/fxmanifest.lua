fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
	"config/moneywash.lua"
}

server_scripts {
	"@_core/libs/utils.lua",
	'server.lua'
}

ui_page "html/index.html"

files {
	"html/*",
	"html/assets/*"
}