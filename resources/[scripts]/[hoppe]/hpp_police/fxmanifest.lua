fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
	'weapon_types.lua',
	'crouch.lua',
	'cancelevent.lua',
	'paramedic.lua'
}

server_scripts {
	"@_core/libs/utils.lua",
	"@mysql-async/lib/MySQL.lua",
	"server.lua"
}

files {
	"html/*"
}

ui_page "html/index.html"

