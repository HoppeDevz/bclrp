function API.getNameById(id)
    local rows = API_Database.query("CKF_/GetCharNameByCharId", {charid = id})
    if #rows > 0 then
        return rows[1].characterName
    end
    return "?"
end

function API.removeMoney(source, value) -- test
    local User = API.getUserFromSource(source)
    local Character = User:getCharacter()
    return Character:removeMoney(source, parseInt(value))
end

--------------------------
-- Save Server Position --
--------------------------

serverPositions	= {}

RegisterServerEvent('updatePosOnServerForPlayer')
AddEventHandler('updatePosOnServerForPlayer', function(newpos)
    local User = API.getUserFromSource(source)
    if User then
        serverPositions[source] = newpos
        User:saveCharacter()
    end
end)

function API.unloadPosForPlayer(source)
	serverPositions[source] = {0.0,0.0,0.0}
end

function API.getPlayerPos(source)
    return table.unpack(serverPositions[source])
end 