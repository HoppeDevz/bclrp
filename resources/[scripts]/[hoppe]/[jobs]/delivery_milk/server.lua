local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("delivery_milk", hpp)

local drugs = {
    "milk_bottle"
}

function hpp.checkDelivery(_Amount)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    local selling = true
    local awardAmount = parseInt(_Amount) * math.random(100, 400)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            for i = 1,#drugs do
                if Character:getItemAmount(drugs[i]) >= parseInt(_Amount) then

                    Character:addItem("generic_blackmoney", parseInt( awardAmount ) )
                    selling = false
                end
            end

            if selling then
                return { error = selling }
            else
                return { error = selling, money_award = awardAmount }
            end
        end
    end
end