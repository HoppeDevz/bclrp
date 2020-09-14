local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("dumptrash", hpp)

function hpp.dumptrash(_Quantity)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = parseInt(Character.id)
            if Character:getItemAmount("generic_trash") >= parseInt(_Quantity) then
                Character:removeItem("generic_trash", parseInt(_Quantity))
                local amount = parseInt(_Quantity) * 100
                Character:addMoney(amount)
                return { error = false, amount = amount }
            else
                return { error = true }
            end
        end
    end
end