fx_version 'adamant'
games { 'gta5' }

client_scripts {
    "@_core/libs/utils.lua",
	"client.lua",
	"weapon_types.lua"
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"@_core/libs/utils.lua",
	"server.lua"
}