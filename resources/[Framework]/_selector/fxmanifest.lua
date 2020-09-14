fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
	"@_core/libs/utils.lua",
	'client.lua',
}

server_scripts {
	"@_core/libs/utils.lua",
	'server.lua'
}

files{
	'./html/*',
	'./html/css/*',
	'./html/font/*',
	'./html/font/poppins/*',
	'./html/img/*',
	'./html/js/*'
}

ui_page 'html/ui.html'