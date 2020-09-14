local itemDatas = {}
local Pickups = {}
local names = {}

animApi = module("_core", "client/functions/_Anims")

local defaultItemData = API.ItemData('????????', '????????', 0.1)

function API.getItemDataFromId(id)
    return itemDatas[id] or defaultItemData
end

function API.getItemDataFromName(name)
    if names[name] ~= nil then
        return itemDatas[names[name]] or defaultItemData
    end
    return defaultItemData
end

function API.useItem(source, id, amount)
    local User = API.getUserFromSource(source)
    local ItemData = API.getItemDataFromId(id)

    if ItemData:getType() == "weapon" then
        local uWeapons = cAPI.getWeapons(source)
        if uWeapons[ItemData:getId():upper()] then
            User:notify(API.Language[API.GameLanguage].WEAPON_EQUIPPED)
            return false
        end
        Citizen.CreateThread(
            function()
                User:giveWeapon(id, 0)
            end
        )
        return true
    elseif ItemData:getType() == "ammo" then
        local uWeapons = cAPI.getWeapons(source)
        local formattedId = ItemData:getId():gsub('ammo_', 'WEAPON_'):upper()
        if uWeapons[formattedId] == nil then
            User:notify(API.Language[API.GameLanguage].NO_WEAPON_TYPE)
            return false
        end
        local equipedAmmo = uWeapons[formattedId]

        Citizen.CreateThread(
            function()
                User:giveWeapon(formattedId, equipedAmmo + amount)
            end
        )
        return true
    elseif ItemData:getType() == "food" then
        local hungerVar = ItemData:getHungerVar()
        if API.varyHunger(source, -hungerVar) then
            TriggerClientEvent("hoppe:eat:anim", source)
            return true
        end
        return false
    elseif ItemData:getType() == "backpack00" then
        User:getCharacter().Inventory:setCapacity(25)
        TriggerEvent("hoppe:save:newcapacity", 25, User:getCharacter().id)
        User:getCharacter():removeItem("backpack00", 1)
    elseif ItemData:getType() == "backpack01" then
        TriggerEvent("hoppe:save:newcapacity", 30, User:getCharacter().id)
        User:getCharacter().Inventory:setCapacity(30)
        User:getCharacter():removeItem("backpack01", 1)
    elseif ItemData:getType() == "backpack02" then
        TriggerEvent("hoppe:save:newcapacity", 38, User:getCharacter().id)
        User:getCharacter().Inventory:setCapacity(38)
        User:getCharacter():removeItem("backpack02", 1)
    elseif ItemData:getType() == "energy" then
        TriggerClientEvent("hoppe:energy:anim", source, 10)
        return true
    elseif ItemData:getType() == "beverage" then
        local thirstVar = ItemData:getThirstVar()
        if API.varyThirst(source, -thirstVar) then 
            TriggerClientEvent("hoppe:drink:anim", source)
            return true
        end
        return false
    elseif ItemData:getType() == "normal" then
        if ItemData:getId() == "generic_money" then
            -- later make a payment system with using item Oo: this is new
        end
    end 
end

function API.dropItem(source, id, amount)
    local User = API.getUserFromSource(source)
    local ItemData = API.getItemDataFromId(id)
    if ItemData:isDroppable() then
        return cAPI.createPickup(source, id, amount, ItemData:getName())
    else 
        User:notify(API.Language[API.GameLanguage].CANNOT_DROP_ITEM)
        return false
    end
end

function API.sendItem(source, id, amount)
    local _source = source
    local User = API.getUserFromSource(source)
    local ItemData = API.getItemDataFromId(id)
    local TargetSource = cAPI.getNearestPlayer(source, RadiusToSendItem)
    if TargetSource ~= 0 then
        local TargetUser = API.getUserFromSource(TargetSource)
        User:getCharacter():getInventory():removeItem(id, amount)
        User:notify(API.Language[API.GameLanguage].SENDED_ITEM.." ["..amount.."x] "..id.." "..API.Language[API.GameLanguage].TO.." "..TargetUser:getCharacter():getName())
        --TriggerClientEvent("Notify", _source, "sucesso", "Enviou x"..amount.." "..id.name.." para "..TargetUser:getCharacter():getName().." ")

        print('TargetUser:getCharacter()', TargetUser:getCharacter())
        TargetUser:getCharacter():getInventory():addItem(id, amount)
        TargetUser:notify(API.Language[API.GameLanguage].RECEIVED_ITEM.." ["..amount.."x] "..id.." "..API.Language[API.GameLanguage].FROM.." "..User:getCharacter():getName())
        --TriggerClientEvent("Notify", _source, "sucesso", "Recebeu x"..amount.." "..id.name.." de "..User:getCharacter():getName().." ")
        return true
    else
        --User:notify(API.Language[API.GameLanguage].NO_NEAREST_PLAYER)
        TriggerClientEvent("Notify", _source, "negado", "Nenhum player próximo!")
        return false
    end
    return false
end

-- drop system
function API.pickupServer(id, amount, name, obj , x, y, z)
    cAPI.sharedPickup(-1, id, amount, name, obj, 1, x, y, z)
    Pickups[obj] = {
        id = id,
        amount = amount,
        name = name,
        obj = obj,
        inRange = false,
        coords = {x = x, y = y, z = z}
    }
end

function API.pickOn(id)
    local pickup  = Pickups[id]

    local _source = source
    local User = API.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            local rest = Character.Inventory:getCapacity() - Character.Inventory:getWeight()
			local ItemData = API.getItemDataFromId(pickup.id)
            local itemWeight = (parseInt(ItemData:getWeight()) * parseInt(pickup.amount))
            
            if parseInt(rest) < parseInt(itemWeight) then
                return false
            end
        end
    end

    cAPI.sharedPickup(-1, pickup.id, pickup.amount, pickup.name, pickup.obj, 2)

    User:getCharacter():getInventory():addItem(pickup.id, pickup.amount)

    cAPI.removeObject(-1, pickup.obj)
    Pickups[id] = nil

    return true
end

Citizen.CreateThread(
    function()
        for id, values in pairs(ItemList) do
            local ItemData = API.ItemData(id, values.name, values.weight or 0.1, values.subtitle, values.type, values.hungerVar, values.thirstVar, values.droppable)

            if id:find('weapon_') then
                ItemData:onUse(
                    function(this, User, amount)
                        local source = User:getSource()
                        local uWeapons = cAPI.getWeapons(source)

                        if uWeapons[id:toupper()] then
                            User:notify(API.Language[API.GameLanguage].WEAPON_EQUIPPED)
                            return false
                        end

                        Citizen.CreateThread(
                            function()
                                User:giveWeapon(id, 0)
                            end
                        )
                        return true
                    end
                )
            end

            if id:find('ammo_') then
                ItemData:onUse(
                    function(this, User, amount)
                        local source = User:getSource()
                        local uWeapons = cAPI.getWeapons(source)
                        local formattedId = id:gsub('ammo_', ''):toupper()

                        if uWeapons[formattedId] == nil then
                            User:notify(API.Language[API.GameLanguage].NO_WEAPON_TYPE)
                            return false
                        end

                        local equipedAmmo = uWeapons[formattedId]

                        Citizen.CreateThread(
                            function()
                                User:giveWeapon(formattedId, equipedAmmo + amount)
                            end
                        )
                        return true
                    end
                )
            end

            if values.type == 'food' then
                ItemData:onUse(
                    function(this, User, amount)
                        local hungerVar = values.hungerVar

                        API.varyHunger(User:getSource(), hungerVar)
                        -- TaskPlayScenario eating
                        -- Wait for Scenario to end
                        -- varyHunger

                        return true
                    end
                )
            end

            if values.type == 'beverage' then
                ItemData:onUse(
                    function(this, User, amount)
                        local thirstVar = values.thirstVar

                        API.varyThirst(User:getSource(), thirstVar)
                        -- TaskPlayScenario drinkin
                        -- Wait for Scenario to end
                        -- varyThirst

                        return true
                    end
                )
            end
            itemDatas[id] = ItemData
            names[values.name] = id
        end
    end
)