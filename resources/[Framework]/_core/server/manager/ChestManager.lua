local chests = {}
local chestsSyncData = {}

-- TABELA CKF_CHESTS

-- id  charid  position       type    capacity
-- 1     1    {150, 20, 10, 10}   1      20

Citizen.CreateThread(
    function()
        local rows = API_Database.query('CKF_/GetChests', {})
        if #rows > 0 then
            for index = 1, #rows do
                local id = rows[index].id
                local type = rows[index].type
                local position = json.decode(rows[index].position)
                local x, y, z, h = table.unpack(position)
                local capacity = rows[index].capacity
                local owner_char_id = rows[index].charid
                local inventories = {}
                local inventoriesRows = API_Database.query('CKF_/Inventory', {id = 'chest:' .. id, charid = 0, capacity = 0, itemName = 0, itemCount = 0, typeInv = 'select'})
                if #inventoriesRows > 0 then
                    for _, data in pairs(inventoriesRows) do
                        local Inventory = API.Inventory(data.id, capacity, json.decode(data.items))
                        local charId = data.charid
                        inventories[tonumber(charId)] = Inventory
                    end
                end
                -- print('loading', id, owner_char_id, x, y, z, h, type, capacity, inventories)

                local groups = {}

                if owner_char_id == nil then
                    groups = ConfigStaticChests[index][7]
                end

                chests[id] = API.Chest(id, owner_char_id, position, type, capacity, inventories, groups)
                chestsSyncData[id] = {capacity, x, y, z, h} -- OUTPUT: [1] = {20, x, y, z ,h}
            end
        else -- Caso não exista nenhum CHEST na table, consequentemente não haverá nenhum CHEST da CONFIG, então cria eles na tablea
            for _, data in pairs(ConfigStaticChests) do
                local x, y, z, h, type, capacity, groups = table.unpack(data)
                -- print('creating chest from config ', _, x, y, z, h, type, capacity)
                local rowsWithId = API_Database.query('CKF_/CreateStaticChest', {position = json.encode({x, y, z, h}), type = type, capacity = capacity})
                if #rowsWithId > 0 then
                    local id = rowsWithId[1].id
                    chests[id] = API.Chest(id, nil, position, type, capacity, {}, groups)
                end
            end
        end
    end
)

-- @param chest id
-- @return Chest Object
-- @exception returns nil if it doesnt exist/hasnt been loaded yet
function API.getChestFromChestId(chestId)
    return chests[chestId]
end

function API.syncChestsWithPlayer(source)
    TriggerClientEvent('CKF:CHESTS:SyncMultipleChests', source, chestsSyncData) -- Vai mandar informaçoes de todos os CHESTS registrados da seguinte forma
    -- {
    --     [chestId1] = {capacity, x, y, z, h},
    --     [chestId2] = {capacity, x, y, z, h},
    --     [chestId3] = {capacity, x, y, z, h},
    --     [chestId4] = {capacity, x, y, z, h},
    -- }
    -- A capacity do CHEST determina o modelo de prop que será usado in-game
end

function API.cacheChest(Chest)
    local chest_id = Chest:getId()
    local chest_capacity = Chest:getCapacity()
    local x, y, z, h = table.unpack(Chest:getPosition())

    chests[chest_id] = Chest

    chestsSyncData[chest_id] = {chest_capacity, x, y, z, h} -- OUTPUT: -- {capacity, x, y, z}
    TriggerClientEvent('CKF:CHESTS:SyncChest', -1, chest_id, chest_capacity, x, y, z, h)
end