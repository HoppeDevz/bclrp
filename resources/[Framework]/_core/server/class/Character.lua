function API.Character(id, charName, level, xp, groups, inventory)
    local self = {}

    self.id = id
    self.charName = charName
    self.level = level or 1
    self.xp = xp or 0
    self.groups = groups or {}
    self.Inventory = inventory or API.Inventory("char:" .. self.id, nil, nil)

    self.getInventory = function()
        return self.Inventory
    end

    self.addGroup = function(this, group)
        if Config_Permissions[group] then
            local groupType = Config_Permissions[group].type
            --print("groupType => "..groupType)
            if groupType ~= nil then
                for tempGroup, _ in pairs(self.groups) do
                    
                    --print("tempGroup => "..tempGroup)
                    --print("underline => ".._)

                    for k,v in pairs(Config_Permissions) do
                        if k == tempGroup then
                            if v.type == groupType then
                                self:removeGroup(k)
                                break
                            end
                        end
                    end

                    --if tempGroupType == groupType then
                        --self:removeGroup(tempGroup)
                        --break
                    --end
                end
            end
            self:setData(self:getId(), "groups", group, true)
            self.groups[group] = true
        end
    end

    self.removeGroup = function(this, group)
        self:remData(self:getId(), "groups", group)
        self.groups[group] = nil
    end

    self.hasGroup = function(this, group)
        return self.groups[group] ~= nil
    end

    self.hasGroupOrInheritance = function(this, group)
        if self.groups[group] then
            return true
        else
            for tempGroup, _ in pairs(self.groups) do
                if Config_Permissions[tempGroup] then
                    local foundInheritanceGroup = Config_Permissions[tempGroup].inheritance
                    if foundInheritanceGroup ~= group then
                        while foundInheritanceGroup ~= nil do
                            foundInheritanceGroup = Config_Permissions[foundInheritanceGroup].inheritance
                            if foundInheritanceGroup == group then
                                return true
                            end
                        end
                    else
                        return true
                    end
                else
                    return false
                end
            end
        end
    end

    self.getId = function()
        return self.id
    end

    self.getName = function()
        return self.charName
    end

    self.getMoney = function()
        return self.Inventory:getItemAmount("generic_money")
    end

    self.addMoney = function(this, money)
        return self.Inventory:addItem("generic_money", parseInt(money))
    end

    self.getItemAmount = function(this, item)
        return self.Inventory:getItemAmount(item)
    end

    self.removeItem = function(this, item, amount)
        return self.Inventory:removeItem(item, parseInt(amount))
    end

    self.addItem = function(this, item, amount)
        return self.Inventory:addItem(item, parseInt(amount))
    end

    self.removeMoney = function(this, money)
        return self.Inventory:removeItem("generic_money", parseInt(money))
    end

    self.getLevel = function()
        return self.level
    end

    self.getXp = function()
        return self.xp
    end

    self.updateLevel = function()
        for level, info in pairs(LevelSystem) do
            local savedLevel = level + 1
            if self.xp < LevelSystem[level].xp then
                self.level = level - 1
                API_Database.execute("CKF_/UpdateLevel", {charid = self:getId(), level = self.level})
                break
            end
        end
    end

    self.addXp = function(this, v)
        self.xp = self.xp + v
        self.updateLevel()
        local xp = API_Database.query("CKF_/UpdateXP", {charid = self:getId(), xp = self.xp})
    end

    self.removeXp = function(this, v)
        self.xp = self.xp - v
        self.updateLevel()
        local xp = API_Database.query("CKF_/UpdateXP", {charid = self:getId(), xp = self.xp})
    end

    self.setWeapons = function(this, weapons)
        API_Database.execute("CKF_/SetCWeaponData", {charid = self:getId(), weapons = json.encode(weapons)})
    end

    self.getModel = function()
        return self:getData(self.id, "skin", "model")
    end

    self.getSkin = function()
        return self:getData(self.id, "skin", nil)
    end

    self.getClothes = function()
        return self:getData(self.id, "clothes", nil)
    end

    --[[
        Targets:
            charTable, groups, clothes
        Keys From charTable:
            hunger, thirst, health
        Keys From Groups:
            admin, user, vip1, vip2
        Keys From Clothes:
            chapeu, camisa, colete, casaco, calca, mascara, botas, luvas, saia, coldre 
        How Works:
            Character.getData(CHARID, TARGETS, KEY)
            Character.setData(CHARID, TARGETS, KEY, VALUE)
            Character.remData(CHARID, TARGETS, KEY)
        
        on put key = nil is all JSON {} 
    ]]
    self.setData = function(this, cid, targetName, key, value)
        API_Database.query("CKF_/SetCData", {target = targetName, key = key, value = value, charid = cid})
    end

    self.getData = function(this, cid, targetName, key)
        if key == nil then
            key = "all"
        end
        local rows = API_Database.query("CKF_/GetCData", {target = targetName, charid = cid, key = key})
        if #rows > 0 then
            return rows[1].Value
        else
            return ""
        end
    end

    self.remData = function(this, cid, targetName, key)
        local rows = API_Database.query("CKF_/RemCData", {target = targetName, key = key, charid = cid})
        if #rows > 0 then
            return true
        end
        return false
    end

    self.playerDead = function()
        self.Inventory:deleteInventory()
    end

    self.savePosition = function(this, source)
        local x, y, z = API.getPlayerPos(source)
        local encoded = {
            ["x"] = tonumber(math.floor(x * 100) / 100),
            ["y"] = tonumber(math.floor(y * 100) / 100),
            ["z"] = tonumber(math.floor(z * 100) / 100)
        }
        self:setData(self:getId(), "charTable", "position", json.encode(encoded))
    end
    
    self.getLastPos = function(this)
        return json.decode(self:getData(self.id, "charTable", "position"))
    end

    self.saveClothes = function(this, source)
        -- THIS NEED OPTIMIZATION!!!!!!!!!!!!!!!!!!!!
        self:setData(self:getId(), "saveClothes", 'ALL', cAPI.getClothesCharacter(source))
    end

    self.saveProfiles = function(this, source)
        -- THIS NEED OPTIMIZATION!!!!!!!!!!!!!!!!!!!!
        self:setData(self:getId(), "saveSkin", 'ALL', cAPI.getSkinCharacter(source))
        --self:setData(self:getId(), "groups", group, true)

        -- cid, targetName, key, value
    end

    self.saveWeapons = function(this, source)
        self:setWeapons(cAPI.getWeapons(source))
    end

    self.getCharHealth = function(this)
        local charinfo = API_Database.query("CKF_/GetCharacter", { charid = self:getId() })
        return charinfo[1].health
    end

    self.saveHealth = function(this)
        local health = cAPI.getHealth(this)
        API_Database.query("CKF_/UpdateCharHealth", { health = health, charid = self:getId() })
    end

    return self
end
