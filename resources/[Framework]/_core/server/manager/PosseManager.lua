
local posses = {}

function API.createPosse(charid, name)
    local User = API.getUserFromCharId(charid)
    local teste = 0
    local members = {
        [charid] = 1, 
        [teste] = 0,
    }   
 --[[
    for k, v in pairs(members) do
        if v == 1 then
           
        end
    end ]]
    
   --[[ local rows = API_Database.query('CKF_/CreatePosse', {charid = charid, name = name, members = json.encode(members)})
    if #rows > 0 then
        local id = rows[1].id
        User:setPosse(id)
        local Posse = API.Posse(id, charid, name, nil)
        posses[id] = Posse
    end  ]]
end

function API.getPosse(id)
    if id ~= nil then
        if posses[id] ~= nil then
            return posses[id]
        else
            local rows = API_Database.query('CKF_/GetPosseById', {id = id})            
            if #rows > 0 then
                
                local Posse = API.Posse(id, rows[1].charid, rows[1].name, json.decode(rows[1].members))                
                posses[id] = Posse
                return Posse
            end
        end
    end

    return nil
end

function API.deletePosse(id)
    posses[id] = nil
end