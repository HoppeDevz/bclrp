fx_version 'adamant'
games { 'gta5' }

ui_page "html/html/inventory.html"

files {
	"html/*",
	"html/fonts/typography/*",
	"html/fonts/icons/*",
	"html/html/*",
	"html/scripts/*",
	"html/styles/*",
	"html/assets/*",
	"html/assets/inventory/*",
}

client_scripts {
	"@_core/libs/utils.lua",
	"client.lua"
}

server_scripts {
	"@_core/libs/utils.lua",
	"server.lua"
}