fx_version 'adamant'
games { 'gta5' }

ui_page "html/html/create-character.html"

files {
	"html/*",
	"html/fonts/typography/*",
	"html/fonts/icons/*",
	"html/html/*",
	"html/scripts/*",
	"html/styles/*",
}

client_scripts {
	"@_core/libs/utils.lua",
	"menus.lua",
	"client.lua",
}

server_scripts {
	"@_core/libs/utils.lua",
	"server.lua"
}