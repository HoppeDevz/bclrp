function API.User(source, id, ipAddress)
    local self = {}

    self.source = source
    self.id = id
    self.ipAddress = ipAddress or '0.0.0.0'
    self.posseId = nil
    self.weapons = nil

    self.save = function()
    end

    self.getSource = function()
        return self.source
    end

    self.getId = function()
        return self.id
    end

    self.getIpAddress = function()
        return ipAddress
    end

    self.getIdentifiers = function()
        local num = GetNumPlayerIdentifiers(self.source)

        local identifiers = {}
        for i = 1, num do
            table.insert(identifiers, GetPlayerIdentifier(self.source, i))
        end

        return identifiers
    end

    self.getCharacters = function()
        local rows = API_Database.query('CKF_/GetCharacters', {user_id = self.id})
        if #rows > 0 then
            return rows
        end
    end


    self.createCharacter = function(this, characterName, age, saves, clothes)

        local numBase0 = math.random(1000,9999)
        local numBase1 = math.random(0,9999)
        local phone_number = string.format("%04d-%04d",numBase0,numBase1)

        local numberexist = API_Database.query('CKF_/CheckNumberPhoneIsExist', { phone = phone_number  })
        while #numberexist > 0 do
            Citizen.Wait(500)
            if #numberexist > 0 then
                numBase0 = math.random(1000,9999)
                numBase1 = math.random(0,9999)
                phone_number = string.format("%04d-%04d",numBase0,numBase1)
                numberexist = API_Database.query('CKF_/CheckNumberPhoneIsExist', { phone = phone_number  })
            end
        end

        local Character = nil
        local rows = API_Database.query('CKF_/CreateCharacter', {user_id = self:getId(), charid = self:getId(), charName = characterName, charAge = age, charSkin = saves, clothes = clothes, money = 5000, phone = phone_number })
        while #rows <= 0 do
            Citizen.Wait(500)
            if #rows <= 0 then
                rows = API_Database.query('CKF_/CreateCharacter', {user_id = self:getId(), charid = self:getId(), charName = characterName, charAge = age, charSkin = saves, clothes = clothes, money = 5000, phone = phone_number })
            end
        end

        local charId = self:getId()

        Character = API.Character(charId, characterName, age, 1, 0, {}, API.Inventory('char:' .. charId, nil, nil))
        local Inventory = Character:getInventory()

        Character:setData(charId, 'charTable', 'hunger', 0)             
        Character:setData(charId, 'charTable', 'thirst', 0)
        Character:setData(charId, 'charTable', 'position', '{"z":13.81,"y":-2738.70,"x":-1038.16}')
                
        API_Database.execute('CKF_/Inventory', {id = 'char:' .. self:getId(), charid = self:getId(), itemName = 0, itemCount = 0, typeInv = 'insert'})
        -- Character:savePosition(self:getSource())
        
        return Character
    end

    self.deleteCharacter = function(this, id)
        API_Database.execute('CKF_/DeleteCharacter', {charid = id})
    end

    self.setCharacter = function(this, id)            
        local charRow = API_Database.query('CKF_/GetCharacter', {charid = id})
        if #charRow > 0 then
            API.chars[id] = self:getId()    
            local rows2 = API_Database.query('CKF_/Inventory', {id = 'char:' .. id, charid = id, itemName = 0, itemCount = 0, typeInv = 'select'})
            local Inventory = nil
            
            if #rows2 > 0 then        
                Inventory = API.Inventory('char:' .. id, parseInt(rows2[1].capacity), json.decode(rows2[1].items))
            end
            
            self.Character = API.Character(id, charRow[1].characterName, charRow[1].level, charRow[1].xp, json.decode(charRow[1].groups), Inventory)
            local weapons = json.decode(charRow[1].weapons) or {}
            self.weapons = weapons
            local posse = API.getPosse(tonumber(json.decode(charRow[1].charTable).posse))            
            if posse ~= nil then
                self.posseId = posse:getId()
            end 
            ---------------- AUTO ADMING GROUP TO USER WITH ID 1
            if self:getId() == 1 then
                if not self.Character:hasGroup('admin') then
                    self.Character:addGroup('admin')
                end
            end
            ---------------- AUTO ADMING GROUP TO USER WITH ID 1 
            self.drawCharacter()
        end
    end

    self.getCharacter = function()
        return self.Character
    end

    self.saveCharacter = function()
        self.Character:savePosition(self:getSource())
        self.Character:saveClothes(self:getSource())
        self.Character:saveProfiles(self:getSource())
        self.Character:saveWeapons(self:getSource())
        self.Character.saveHealth(self:getSource())
    end

    self.drawCharacter = function() 
        --cAPI.setHealth(self:getSource(), 200)  
        if cAPI.setModel(self:getSource(), json.decode(self.Character:getModel())) then
            Wait(200) 
            --cAPI.setHealth(self:getSource(), 200)       
            if cAPI.setSkin(self:getSource(), self.Character:getSkin()) then
                --cAPI.setHealth(self:getSource(), 200) 
                if cAPI.setClothes(self:getSource(), self.Character:getClothes()) then
                    cAPI.replaceWeapons(self:getSource(), self.weapons) 
                    cAPI.teleportSpawn(self:getSource(), self.Character:getLastPos(self:getSource()))     
                    cAPI.startNeeds(self:getSource())
                    cAPI.setHealth( self:getSource(), self.Character:getCharHealth(self:getSource()) )
                    Citizen.Wait(500)
                    cAPI.setHealth( self:getSource(), self.Character:getCharHealth(self:getSource()) )
                end       
            end
        end
    end

    self.disconnect = function(this, reason)
        DropPlayer(self:getSource(), reason)
    end

    self.viewInventory = function()
        if self.Character ~= nil then
            self:viewInventoryAsPrimary(self.Character:getInventory())
        end
    end

    self.viewInventoryAsPrimary = function(this, Inventory)
        self.primaryViewingInventory = Inventory
        Inventory:viewAsPrimary(self:getSource())
    end

    self.viewInventoryAsSecondary = function(this, Inventory)
        self.secondaryViewingInventory = Inventory
        Inventory:viewAsSecondary(self:getSource())
    end

    self.closeInventory = function()
        -- TriggerClientEvent('CKF_inventory:closeInv', self:getSource())

        if self.primaryViewingInventory ~= nil then
            self.primaryViewingInventory:removeViewer(self:getSource())
            self.primaryViewingInventory = nil
        end

        if self.secondaryViewingInventory ~= nil then
            self.secondaryViewingInventory:removeViewer(self:getSource())
            self.secondaryViewingInventory = nil
        end
    end

    self.getPrimaryInventoryViewing = function()
        return self.primaryViewingInventory
    end

    self.getSecondaryInventoryViewing = function()
        return self.secondaryViewingInventory
    end

    self.notify = function(this, v)
        TriggerClientEvent("chatMessage", self:getSource(), v)
    end

    self.getWeapons = function()
        return cAPI.getWeapons(self:getSource())
    end

    self.giveWeapon = function(this, weapon, ammo)
        self:giveWeapons({[weapon] = ammo})
    end

    self.giveWeapons = function(this, array)
        cAPI.giveWeapons(self:getSource(), array, false)
        self.Character:setWeapons(cAPI.getWeapons(self:getSource()))
    end

    self.removeWeapon = function(this, weapon)
        self:removeWeapons({weapon})
    end

    self.removeWeapons = function(this, array)
        local weapons = cAPI.getWeapons(self:getSource())
        for _, weapon in pairs(array) do
            weapons[weapon] = nil
        end
        cAPI.replaceWeapons(self:getSource(), weapons)
        self.Character:setWeapons(cAPI.getWeapons(self:getSource()))
    end

    self.replaceWeapons = function(this, array)
        cAPI.replaceWeapons(self:getSource(), array)
        self.Character:setWeapons(cAPI.getWeapons(self:getSource()))
    end

    self.setPosse = function(this, id)
        self.posseId = id

        TriggerClientEvent('CKF:POSSE:SetPosse', self:getSource(), id)

        if id ~= nil then
            self:getCharacter():setData(self:getCharacter():getId(), 'charTable', 'posse', id)
        else
            self:getCharacter():remData(self:getCharacter():getId(), 'charTable', 'posse')
        end
    end

    self.getPosseId = function()
        return self.posseId
    end

    self.isInAPosse = function()
        return self.posseId ~= nil
    end

    return self
end
