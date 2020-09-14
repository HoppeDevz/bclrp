cAPI.drawable_names = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"}
cAPI.head_overlays = {"0","1","2","3","4","5","6","7","8","9","10","11","12"}
cAPI.face_features = {"0","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"}

function cAPI.getDrawableNames()
    return cAPI.drawable_names
end

function cAPI.getHeadOverlays()
    return cAPI.head_overlays
end

function cAPI.getFaceFeatures()
    return cAPI.face_features
end

function cAPI.SetPedHeadBlend(data)
    if data then
        local player = PlayerPedId()
        SetPedHeadBlendData(player,
            tonumber(data['s1']),
            tonumber(data['s2']),
            tonumber(data['s3']),
            tonumber(data['s4']),
            tonumber(data['s5']),
            tonumber(data['s6']),
            tonumber(data['s7']),
            tonumber(data['s8']),
            tonumber(data['s9']),
        false)
    end
end

function cAPI.SetHeadOverlayData(data)
	local player = PlayerPedId()
    if json.encode(data) ~= "[]" then
        for i = 1, #data do
            SetPedHeadOverlay(player, (i - 1), tonumber(data[i].ov),  tonumber(data[i].oo))
            SetPedHeadOverlayColor(player, (i - 1), data[i].ct, data[i].fc, data[i].sc)

            --print("data[i].ov", data[i].ov)
            --print("i", i)
        end

        --headData[i] = {}
        --headData[i].name = cAPI.getHeadOverlays()[i]
        --headData[i].ov = overlayValue --
        --headData[i].fc = firstColour -- 
        --headData[i].sc = secondColour --
        --headData[i].oo = string.format("%.2f", overlayOpacity) --

        --SetPedHeadOverlayColor(player, 0, 0, tonumber(data[1].fc), tonumber(data[1].sc))
        --SetPedHeadOverlayColor(player, 1, 1, tonumber(data[2].fc), tonumber(data[2].sc))
        --SetPedHeadOverlayColor(player, 2, 1, tonumber(data[3].fc), tonumber(data[3].sc))
        --SetPedHeadOverlayColor(player, 3, 0, tonumber(data[4].fc), tonumber(data[4].sc))
        --SetPedHeadOverlayColor(player, 4, 2, tonumber(data[5].fc), tonumber(data[5].sc))
        --SetPedHeadOverlayColor(player, 5, 2, tonumber(data[6].fc), tonumber(data[6].sc))
        --SetPedHeadOverlayColor(player, 6, 0, tonumber(data[7].fc), tonumber(data[7].sc))
        --SetPedHeadOverlayColor(player, 7, 0, tonumber(data[8].fc), tonumber(data[8].sc))
        --SetPedHeadOverlayColor(player, 8, 2, tonumber(data[9].fc), tonumber(data[9].sc))
        --SetPedHeadOverlayColor(player, 9, 0, tonumber(data[10].fc), tonumber(data[10].sc))
        --SetPedHeadOverlayColor(player, 10, 1, tonumber(data[11].fc), tonumber(data[11].sc))
        --SetPedHeadOverlayColor(player, 11, 0, tonumber(data[12].fc), tonumber(data[12].sc))
    end
end

function cAPI.SetHeadStructure(data)
	local player = PlayerPedId()
    for i = 1, #cAPI.face_features do
        SetPedFaceFeature(player, i-1, data[i])
    end
end

function cAPI.SetClothing(drawables, drawTextures)
	local player = PlayerPedId()
    for i = 1, #cAPI.drawable_names do
        if drawables[0] == nil then
            if cAPI.drawable_names[i] == "9" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if cAPI.drawable_names[i] == "9" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end
end

function cAPI.SetHairColor(data)
	local player = PlayerPedId()
	SetPedHairColor(player, tonumber(data[1]), tonumber(data[2]))
end

function cAPI.GetDrawables()
    local player = PlayerPedId()
    drawables = {}
    local model = GetEntityModel(PlayerPedId())
    local mpPed = false
    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then
        mpPed = true
    end
    for i = 0, #cAPI.getDrawableNames()-1 do
        if mpPed and cAPI.getDrawableNames()[i+1] == "9" and GetPedDrawableVariation(player, i) == -1 then
            SetPedComponentVariation(player, i, 15, 0, 2)
        end
        drawables[i] = {cAPI.getDrawableNames()[i+1], GetPedDrawableVariation(player, i)}
    end
    return drawables
end

function cAPI.GetDrawTextures()
    local player = PlayerPedId()
    textures = {}
    for i = 0, #cAPI.getDrawableNames()-1 do
        table.insert(textures, {cAPI.getDrawableNames()[i+1], GetPedTextureVariation(player, i)})
    end
    return textures
end

function cAPI.GetPedHeadBlendData()
    local player = PlayerPedId()
    local blob = string.rep("\0\0\0\0\0\0\0\0", 6 + 3 + 1) -- Generate sufficient struct memory.
    if not Citizen.InvokeNative(0x2746BD9D88C5C5D0, player, blob, true) then -- Attempt to write into memory blob.
        return nil
    end

    return {
        s1 = string.unpack("<i4", blob, 1),
        s2 = string.unpack("<i4", blob, 9),
        s3 = string.unpack("<i4", blob, 17),
        s4 = string.unpack("<i4", blob, 25),
        s5 = string.unpack("<i4", blob, 33),
        s6 = string.unpack("<i4", blob, 41),
        s7 = string.unpack("<f", blob, 49),
        s8 = string.unpack("<f", blob, 57),
        s9 = string.unpack("<f", blob, 65),
        s10 = string.unpack("b", blob, 73) ~= 0,
    }
end

function cAPI.GetHeadOverlayData()
    local player = PlayerPedId()
    local headData = {}
    for i = 1, #cAPI.getHeadOverlays() do
        local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(player, i-1)
        if retval then
            headData[i] = {}
            headData[i].name = cAPI.getHeadOverlays()[i]
            headData[i].ct = colourType
            headData[i].ov = overlayValue --
            headData[i].fc = firstColour -- 
            headData[i].sc = secondColour --
            headData[i].oo = string.format("%.2f", overlayOpacity) --

            --print("overlayValue", overlayValue)
            --print("i - 1", i)
            --print("firstColour", firstColour)
        end
    end
    return headData
end

function cAPI.GetPedHair()
    local player = PlayerPedId()
    local hairColor = {}
    hairColor[1] = GetPedHairColor(player)
    hairColor[2] = GetPedHairHighlightColor(player)
    return hairColor
end

function cAPI.GetHeadStructureData()
    local player = PlayerPedId()
    local structure = {}
    for i = 1, #cAPI.getFaceFeatures() do
        structure[cAPI.getFaceFeatures()[i]] = GetPedFaceFeature(player, i-1)
    end
    return structure
end

function cAPI.getClothesCharacter()
    Clothes = {
        drawables = cAPI.GetDrawables(),
        drawTextures = cAPI.GetDrawTextures()
    }
    return json.encode(Clothes)
end

function cAPI.getSkinCharacter()
    sendAll = {
        model = GetEntityModel(PlayerPedId()),
        headBlend = cAPI.GetPedHeadBlendData(),
        overlayHead = cAPI.GetHeadOverlayData(),
        headStruct = cAPI.GetHeadStructureData(),
        getHair = cAPI.GetPedHair()
    }
    return json.encode(sendAll)
end