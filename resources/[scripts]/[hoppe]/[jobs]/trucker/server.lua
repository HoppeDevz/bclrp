local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("trucker", hpp)

function hpp.checkReward(_Distance)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = parseInt(Character.id)

            local amount = parseInt(_Distance)

            Character:addMoney(amount)

            return amount
        end
    end
end