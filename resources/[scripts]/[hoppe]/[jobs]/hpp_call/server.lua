local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_call", hpp)

local calls = {}

RegisterNetEvent("hoppe:call:send")
AddEventHandler("hoppe:call:send", function(_Perm, _Message, _x, _y, _z)
    table.insert( calls, 1, { _x, _y, _z, false  } ) -- x,y,z acept-status
    TriggerClientEvent("hoppe:call:send", -1, _Perm, _Message, _x, _y, _z)
end)

RegisterNetEvent("hoppe:call:acept")
AddEventHandler("hoppe:call:acept", function(x,y,z, Message)
    local _source = source
    for k,v in pairs(calls) do
        if v[1] == x then
            if not v[4] then
                calls[k][4] = true
                TriggerClientEvent("hoppe:call:set:waypoint", _source, x,y,z, Message)
                return TriggerClientEvent("hoppe:delete:ocorrence", _source, x,y,z)
            else
                TriggerClientEvent("Notify", _source, "negado", "Alguém já aceitou este chamado!")
                return TriggerClientEvent("hoppe:delete:ocorrence", _source, x,y,z)
            end
        end
    end
end)

function hpp.checkCall(x,y,z)
    for p,j in pairs(calls) do
        if j[1] == x then
            return j[4]
        end
    end
end 

function hpp.hasGroup(_GroupName)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = parseInt(Character.id)
            return Character:hasGroup(_GroupName)
        end 
    end
end