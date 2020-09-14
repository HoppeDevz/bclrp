local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_anticheat", hpp)

function hpp.getCharId()
    local _source = source
	local User = APICKF.getUserFromSource(_source)
	if User then
		local Character = User:getCharacter()
		if Character then
            local charid = Character.id
            return charid
        end
    end
    _source = nil
end

function hpp.isAdmin()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
	if User then
		local Character = User:getCharacter()
		if Character then
            local charid = Character.id
            return Character:hasGroup("admin") or Character:hasGroup("moderator")
        end
    end
    charid = nil
    Character = nil
    User = nil
    _source = nil
end