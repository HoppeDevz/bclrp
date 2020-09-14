local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_sedexcars", hpp)

local vans = {
    -- { GetHashKey: 'xxxx', BoxNumber: xy }
    -- { GetHashKey = "xyz", BoxNumber = 20 }
}

function hpp.checkExistVan(_HashKey)
    if #vans == 0 or #vans == "0" then
        return { exist = false }
    else
        for i = 1,#vans do
            if vans[i].GetHashKey == _HashKey then
                return { exist = true, BoxNumber = vans[i].BoxNumber }
            end
        end

        return { exist = false }
    end
end

function hpp.updateboxamount(_HashKey, _Number)
    for i = 1,#vans do
        if vans[i].GetHashKey == _HashKey then
            vans[i].BoxNumber = vans[i].BoxNumber + parseInt(_Number)
        end
    end
end

function hpp.getBoxAmount(_HashKey)
    for i = 1,#vans do
        if vans[i].GetHashKey == _HashKey then
            return vans[i].BoxNumber
        end
    end
end

function hpp.givereward()
    local amount = math.random(100, 300)
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

function hpp.registerCar(_HashKey)
    table.insert(vans, 1, { GetHashKey = _HashKey, BoxNumber = 0 } )
end

Citizen.CreateThread(function()
    --print('GetHashKey', vans[1].GetHashKey)
    --print('BoxNumber', vans[1].BoxNumber)
    print(#vans)
end)


