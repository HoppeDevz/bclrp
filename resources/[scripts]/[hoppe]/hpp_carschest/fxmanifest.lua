fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
}

server_scripts {
	"@_core/libs/utils.lua",
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

files {
	"html/*",
	"html/assets/*"
}

ui_page "html/index.html"

