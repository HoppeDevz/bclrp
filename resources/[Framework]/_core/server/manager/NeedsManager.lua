function API.varyHunger(source, variation)
    local User = API.getUserFromSource(source)
    if User == nil then
        return
    end
    local Character = User:getCharacter()
    if Character == nil then
        return
    end

    local hunger = json.decode(Character:getData(Character:getId(), 'charTable', 'hunger'))
    hunger = tonumber(hunger)
    if hunger then
        local was_starving = hunger >= 100
        hunger = hunger + variation
        local is_starving = hunger >= 100

        local overflow = hunger - 100
        if overflow > 0 then
            --vary health
            --cAPI.varyHealth(source, -overflow * 8)
        end

        if hunger < 0 then
            hunger = 0
        elseif hunger > 100 then
            hunger = 100
        end
        Character:setData(Character:getId(), 'charTable', 'hunger', tonumber(math.floor(hunger * 100) / 100))
    end
    return true
end

function API.varyThirst(source, variation)
    local User = API.getUserFromSource(source)

    if User == nil then
        return
    end

    local Character = User:getCharacter()

    if Character == nil then
        return
    end

    local thirst = json.decode(Character:getData(Character:getId(), 'charTable', 'thirst'))
    thirst = tonumber(thirst)
    if thirst then
        local was_starving = thirst >= 100
        thirst = thirst + variation
        local is_starving = thirst >= 100

        local overflow = thirst - 100
        if overflow > 0 then
            --vary health
            --cAPI.varyHealth(source, -overflow * 8)
        end

        if thirst < 0 then
            thirst = 0
        elseif thirst > 100 then
            thirst = 100
        end

        Character:setData(Character:getId(), 'charTable', 'thirst', tonumber(math.floor(thirst * 100) / 100))
    end
    return true
end