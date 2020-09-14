fx_version "adamant"
games { "gta5" }

client_scripts {
	"@_core/libs/utils.lua",
    "client.lua",
    "config/cfg.lua"
}

server_scripts {
	"@_core/libs/utils.lua",
    "server.lua"
}

ui_page "web/index.html"

files {
    "web/*",
    "assets/*"
}