local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_invHUD", hpp)


function hpp.getCapacity()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            return Character.Inventory:getCapacity()
        end
    end
end

function hpp.getWeight()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            return Character.Inventory:getWeight()
        end
    end
end