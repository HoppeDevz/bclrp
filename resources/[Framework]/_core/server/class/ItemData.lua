function API.ItemData(id, name, weight, subTitle, type, hungerVar, thirstVar, droppable)
    local self = {}

    self.id = id
    self.name = name
    self.weight = weight
    self.type = type
    self.subTitle = subTitle or "NULL"
    self.hungerVar = hungerVar or 0
    self.thirstVar = thirstVar or 0
    self.droppable = droppable 
    -- self.worldModel = 'default_prop'

    self.getId = function()
        return self.id
    end

    self.getName = function(this)
        return self.name
    end

    self.isDroppable = function(this)
        return self.droppable
    end

    self.getSubTitle = function(this)
        return self.subTitle
    end

    self.getWeight = function()
        return self.weight
    end

    self.getType = function()
        return self.type
    end

    self.getHungerVar = function()
        return self.hungerVar
    end

    self.getThirstVar = function()
        return self.thirstVar
    end

    -- # Caso queria fazer um ItemDrop com um prop
    --
    -- self.getWorldModel = function()
    --     return self.worldModel
    -- end

    self.onUse = function(this, v)
        self.use = v
    end

    self.use = function(this, User)
        return false
    end

    return self
end