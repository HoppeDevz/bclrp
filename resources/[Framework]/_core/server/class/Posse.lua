function API.Posse(id, charid, name, members)
    local self = {}
    self.id = id
    self.charid = charid
    self.name = name
    self.members = members or {[self.charid] = 1}

    self.getId = function()
        return self.id
    end

    self.getCharId = function()
        return self.charid
    end

    self.getName = function()
        return self.name
    end

    self.getMembers = function()
        return self.members
    end

    self.isAMember = function(this, charid)
        return self.members[charid] ~= nil
    end

    self.getMemberRank = function(this, charid)
        return self.members[charid] or 0
    end

    self.notifyMembers = function()
    end

    self.promoteMember = function(this, charid)
        if self.members[charid] then
            self.members[charid] = self.members[charid] - 1
        end
    end

    self.demoteMember = function(this, charid)
        if self.members[charid] then
            self.members[charid] = self.members[charid] + 1
        end
    end

    -- 1 - Owner
    -- 2 - Leader
    -- 3 - Member
    self.addMember = function(this, User, rank)
        User:setPosse(self.id)

        self.members[User:getCharacter():getId()] = rank

        API_Database.query('CKF_/PosseRoutine', {id = id, charid = User:getCharacter():getId(), rank = rank, type = 'update'})
    end

    self.removeMember = function(this, charid)
        if self.members[charid] then
            local rank = self.members[charid]

            if rank == 1 then
                for memberCharId, rank in pairs(self.members) do
                    local UserMember = API.getUserFromCharId(memberCharId)

                    if UserMember ~= nil and UserMember:getCharacter():getId() == memberCharId then
                        UserMember:setPosse(nil)
                        UserMember:notify('O bando em qual você estava foi deletado!')
                    else
                        API.Character:remData(memberCharId, 'charTable', 'posse')
                    end
                end

                API.deletePosse(self.id)
                API_Database.query('CKF_/PosseRoutine', {id = id, charid = 0, rank = 0, type = 'delete'}) -- Deletar a Row da Posse
            else
                local UserMember = API.getUserFromCharId(charid)

                if UserMember ~= nil and UserMember:getCharacter():getId() == charid then
                    UserMember:setPosse(nil)
                else
                    API.Character:remData(charid, 'charTable', 'posse')
                end

                self:notifyMembers('CharId ' .. charid .. ' saiu do bando!')
                self.members[charid] = nil
            end
        end
    end

    return self
end