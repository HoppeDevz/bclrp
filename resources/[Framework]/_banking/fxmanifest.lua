fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "html/html/bank.html"

files {
	"html/*",
	"html/fonts/typography/*",
	"html/fonts/icons/*",
	"html/html/*",
	"html/scripts/*",
	"html/styles/*",
	"html/assets/*",
}

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
}

server_scripts {
	"@_core/libs/utils.lua",
	'server.lua'
}