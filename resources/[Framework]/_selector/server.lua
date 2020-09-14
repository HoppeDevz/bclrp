local Tunnel = module("_core","libs/Tunnel")
local Proxy = module("_core","libs/Proxy")

API = Proxy.getInterface("API")
cAPI = Tunnel.getInterface("cAPI")

RegisterServerEvent('CKF_identity:charList')
AddEventHandler('CKF_identity:charList', function(source)
    local _source = source

    if _source == nil then
        return
    end

    local User = API.getUserFromSource(_source)

    local characters = User:getCharacters()

    --retry
    if not characters then
        Citizen.Wait(1000)
        characters = User:getCharacters()
    end

    --retry 2
    if not characters then
        Citizen.Wait(1000)
        characters = User:getCharacters()
    end

    --retry 3
    if not characters then
        Citizen.Wait(1000)
        characters = User:getCharacters()
    end

    --print("_source", _source)
    --print("characters", characters)
 
    if User:getId() then
        TriggerClientEvent('CKF_identity:charList', _source, characters)
    end
end)

RegisterServerEvent('CKF_identity:charListWithUser')
AddEventHandler('CKF_identity:charListWithUser', function(User)
    if User:getId() then
        TriggerClientEvent('CKF_identity:charList', User:getSource(), User:getCharacters())
    end
end)

RegisterServerEvent('CKF_identity:selectCharacter')
AddEventHandler('CKF_identity:selectCharacter', function(cid) 
    local _source = source
    local User = API.getUserFromSource(_source) 
    User:setCharacter(cid) 
end)

RegisterServerEvent('CKF_identity:deleteCharacter')
AddEventHandler('CKF_identity:deleteCharacter', function(cid)
    local _source = source
    local User = API.getUserFromSource(_source)
    User:deleteCharacter(cid)
    TriggerEvent('CKF_identity:charList', _source, _source)
end)
