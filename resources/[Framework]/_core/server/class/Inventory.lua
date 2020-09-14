  
function API.Inventory(id, capacity, items)
    local self = {}

    self.id = id
    self.capacity = capacity or 5
    self.items = items or {}
    self.viewersSources = {}

    self.getId = function()
        return self.id
    end

    self.getItems = function()
        return self.items
    end

    self.getWeight = function()
        local weight = 0
        for id, amount in pairs(self.items) do
            local ItemData = API.getItemDataFromId(id)
            if ItemData ~= nil then
                weight = weight + (ItemData:getWeight() * amount)
            end
        end
        --print(weight)
        return weight
    end

    self.setCapacity = function(this, v)
        self.capacity = v
    end

    self.getCapacity = function()
        return self.capacity
    end

    self.getCharId = function()
        if string.find(self:getId(), "char:") then
            local charid = string.sub(self:getId(), string.find(self:getId(), "char:") + 5)
            return tonumber(charid) or 0
        end
        return 0
    end

    self.addItem = function(this, id, amount)
        local ItemData = API.getItemDataFromId(id)
        if ItemData == nil then
            return false
        end

        local _temp = self.items[id] or 0
        _temp = _temp + amount

        self.items[id] = _temp

        API_Database.execute(
            "CKF_/Inventory",
            {id = self:getId(), charid = self:getCharId(), itemName = id, itemCount = _temp, typeInv = "update"}
        )
        for viewerSource, asPrimary in pairs(self.viewersSources) do
            local User = API.getUserFromSource(viewerSource)

            if asPrimary then
                -- i need change this to prevent inject :D
                TriggerClientEvent("_inventory:updateItems", viewerSource, self:updateItem())
                TriggerClientEvent("hoppe:hud:update", viewerSource)
                --User:notify("Inventário Principal: + x" .. amount .. " " .. ItemData:getName())
            else
                --TriggerClientEvent(
                --    "CKF:INVENTORY:SecondarySyncItemAmount",
                --    viewerSource,
                --    id,
                --    _temp,
                --    ItemData:getName()
                --)
                --User:notify("Inventário Secundário: + x" .. amount .. " " .. ItemData:getName())
            end
        end

        return true
    end

    self.updateItem = function(this)
        local parsedItems = {}
        for id, amount in pairs(self.items) do
            local ItemData = API.getItemDataFromId(id)
            table.insert(
                parsedItems,
                {
                    id = id,
                    amount = amount,
                    name = ItemData:getName(),
                    weight = ItemData:getWeight(),
                    subtitle = ItemData:getSubTitle(),
                    type = ItemData:getType()
                }
            )
        end
        return parsedItems
    end

    self.removeItem = function(this, id, amount)
        if self.items[id] then
            local _temp = self.items[id] or 0
            _temp = _temp - amount

            if _temp > 0 then
                self.items[id] = _temp
                API_Database.execute(
                    "CKF_/Inventory",
                    {id = self:getId(), charid = self:getCharId(), itemName = id, itemCount = _temp, typeInv = "update"}
                )
            else
                self.items[id] = nil
                API_Database.execute(
                    "CKF_/Inventory",
                    {id = self:getId(), charid = self:getCharId(), itemName = id, itemCount = 0, typeInv = "remove"}
                )
            end

            local ItemData = API.getItemDataFromId(id)
            for viewerSource, asPrimary in pairs(self.viewersSources) do
                -- Update
                local User = API.getUserFromSource(viewerSource)

                if asPrimary then
                    --TriggerClientEvent(
                    --    "CKF:INVENTORY:PrimarySyncItemAmount",
                    --    viewerSource,
                    --    id,
                    --    _temp,
                    --    ItemData:getName()
                    --)
                    TriggerClientEvent("_inventory:updateItems", viewerSource, self:updateItem())
                    TriggerClientEvent("hoppe:hud:update", viewerSource)
                    --User:notify("Inventário Principal: - x" .. amount .. " " .. ItemData:getName())
                else
                    --TriggerClientEvent(
                    --    "CKF:INVENTORY:SecondarySyncItemAmount",
                    --    viewerSource,
                    --    id,
                    --    _temp,
                    --    ItemData:getName()
                    --)
                    --User:notify("Inventário Secundário: - x" .. amount .. " " .. ItemData:getName())
                end
            end

            return true
        end

        return false
    end

    self.getItemAmount = function(this, item_id)
        local amount = self.items[item_id] or 0
        return amount
    end

    self.hasItem = function(this, item_id)
        return self:getItemAmount(item_id) > 0
    end

    self.viewAsPrimary = function(this, viewerSource)
        self.viewersSources[viewerSource] = true

        local parsedItems = {}
        for id, amount in pairs(self.items) do
            local ItemData = API.getItemDataFromId(id)
            table.insert(
                parsedItems,
                {
                    id = id,
                    amount = amount,
                    name = ItemData:getName(),
                    weight = ItemData:getWeight(),
                    subtitle = ItemData:getSubTitle(),
                    type = ItemData:getType()
                }
            )
        end

        TriggerClientEvent("_inventory:clientReceived", viewerSource, parsedItems)
    end

    self.viewAsSecondary = function(this, viewerSource)
        self.viewersSources[viewerSource] = false

        local parsedItems = {}
        for id, amount in pairs(self.items) do
            local ItemData = API.getItemDataFromId(id)
            table.insert(
                parsedItems,
                {
                    id = id,
                    amount = amount,
                    name = ItemData:getName(),
                    subtitle = ItemData:getSubTitle(),
                    type = ItemData:getType()
                }
            )
        end

        TriggerClientEvent("_inventory:clientReceivedSecondary", viewerSource, parsedItems)
    end

    self.removeViewer = function(this, viewerSource)
        self.viewersSources[viewerSource] = nil
    end

    self.deleteInventory = function(self)
        API_Database.execute(
            "CKF_/Inventory",
            {id = self:getId(), charid = self:getCharId(), itemName = 0, itemCount = 0, typeInv = "deadPlayer"}
        )
        self.items = nil
    end

    self.useItem = function(this, source, id, amount)
        if not self:hasItem(id) then return end
        if self:getItemAmount(id) < parseInt(amount) then  return end
        if API.useItem(source, id, parseInt(amount)) then
            self:removeItem(id, parseInt(amount))
        end
    end

    self.dropItem = function(this, source, id, amount)
        if not self:hasItem(id) then return end
        if self:getItemAmount(id) < parseInt(amount) then  return end
        if API.dropItem(source, id, parseInt(amount)) then
            self:removeItem(id, parseInt(amount))
        end
    end

    self.sendItem = function(this, source, id, amount)
        if not self:hasItem(id) then return end
        if self:getItemAmount(id) < parseInt(amount) then  return end
        API.sendItem(source, id, parseInt(amount))
    end

    return self
end