local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local cfg = module("vrp_doors","config")

RegisterServerEvent('vrpdoorsystem:open')
AddEventHandler('vrpdoorsystem:open',function(id)
	local source = source
	local _source = source
	local User = APICKF.getUserFromSource(_source)
	if User then
		local Character = User:getCharacter()
		if Character then
			if Character:hasGroup(cfg.list[id].perm) then
				cfg.list[id].lock = not cfg.list[id].lock
				TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,cfg.list[id].lock)
				if cfg.list[id].other ~= nil then
					local idsecond = cfg.list[id].other
					cfg.list[idsecond].lock = cfg.list[id].lock
					TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,cfg.list[id].lock)
				end
			end
		end
	end
end)