local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("tokoradio")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local currentchannel = 0

RegisterCommand("radiof", function(source, args, rawCommand)
    print( 'hpp.isHaveRadio()', hpp.isHaveRadio() )
    if tonumber(hpp.isHaveRadio()) == 0 then
        return TriggerEvent("Notify", "negado", "Você precisa de um rádio!")
    end
    if tonumber(args[1]) == nil then
        return TriggerEvent("Notify", "negado", "Radio inválida!")
    end

    currentchannel = parseInt(tonumber(args[1]))
    TriggerServerEvent("TokoVoip:addPlayerToRadio", parseInt(tonumber(args[1])), GetPlayerServerId(PlayerId()));
end)

RegisterCommand("radiod", function(source, args, rawCommand)
    TriggerServerEvent("TokoVoip:removePlayerFromRadio", currentchannel, GetPlayerServerId(PlayerId()));
    TriggerEvent("Notify", "sucesso", "Você saiu da rádio "..currentchannel.."MHz");

    currentchannel = 0
end)