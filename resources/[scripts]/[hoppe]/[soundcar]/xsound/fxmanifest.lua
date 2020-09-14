fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/events.lua",
	"client/hppclient.lua",
	"@NativeUI/NativeUI.lua",
    "client/menu.lua",

	"client/exports/info.lua",
	"client/exports/play.lua",
	"client/exports/manipulation.lua",

	"client/emulator/interact_sound/client.lua",
}

server_scripts {
	"server/exports/play.lua",
	"server/exports/manipulation.lua",
	"server/hppserver.lua",

	"server/emulator/interact_sound/server.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",
	
	"html/scripts/config.js",
	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	"html/scripts/functions.js",

	"html/sounds/*.ogg",
	"html/sounds/*.mp3",
}