fx_version 'adamant'
games { 'gta5' }

ui_page "nui/ui.html"
dependency 'blip_info'

client_scripts {
	"client.lua"
}

server_scripts {
	"@_core/libs/utils.lua",
	"server.lua"
}

files {
	"nui/*",
	'assets/*'
}