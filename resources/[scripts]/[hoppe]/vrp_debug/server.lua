local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

func = {}
Tunnel.bindInterface("vrp_debug",func)

function func.checkIP()
	local user_id = vRP.getUserId(source)
	return GetPlayerEndpoint(source)
end	

function func.checkPermission()
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"admin.permissao")
end		