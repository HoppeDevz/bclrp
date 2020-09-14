function API.Quests(id, quests)
    local self = {}

    self.id = id
    self.quests = quests or {}

    self.addQuest = function(name, step)
        self.quests[name] = step
    end

    self.remQuest = function(name)
        self.quests[name] = nil
    end

    self.updateQuest = function(name, step)
        self.quests[name] = step
    end

    return self
end