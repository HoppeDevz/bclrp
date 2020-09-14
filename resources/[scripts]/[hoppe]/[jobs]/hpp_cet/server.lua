local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_cet", hpp)

function hpp.givereward()
    local amount = math.random(300, 900)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = parseInt(Character.id)
            Character:addItem( "generic_money", parseInt(amount) )
            return amount
        end
    end
end