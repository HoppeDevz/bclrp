local Proxy = module('_core', 'libs/Proxy')
local Tunnel = module('_core', 'libs/Tunnel')

cAPI = Proxy.getInterface('cAPI')
API = Tunnel.getInterface('API')

initialPositionList = { 
    { x = 152.19 , y = -1001.41 , z = -99.00, h = 200.00 }, -- 1
    { x = 9.07 , y = 527.27 , z = 170.63, h = 24.91 }, -- 2
    { x = -226.38 , y = -2002.65 , z = 24.68, h = 166.024 }, -- 3
    { x = 988.55, y = -97.304, z = 74.845, h = 125.3 }, -- 4
    { x = -571.79 , y = 286.08 , z = 79.17, h = 35.42 }, -- 5
    { x = 727.08 , y = -2984.85 , z = -38.99, h = 218.467 }, -- 6
    { x = 727.08 , y = -2984.85 , z = -38.99, h = 218.467 }, -- 7
    { x = 1009.05 , y = -3164.81 , z = -34.07, h = 114.70 }, -- 8
    { x = 1001.13 , y = -3168.96 , z = -34.07, h = 320.04 }, -- 9
    { x = -591.72 , y = -285.078 , z = 35.45, h = 267.35 }, -- 10
    { x = -1006.64, y = -479.85, z = 50.0, h = 327.467 }, -- 11
    { x = -1003.77, y = -478.363, z = 50.02, h = 78.467 } -- 12
}

initialPosition = initialPositionList[math.random(1, 12)]

-- Citizen.CreateThread(function() print('initialPosition', json.encode(initialPosition)) end)

spawnAfterCreation = {x = -1038.115234375,y = -2738.6081542969,z= 13.815234184265}

cameraUsing = {
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.PARENTS,
        x=0.0,
        y=-0.8,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYES,
        x=0.0,
        y=-0.4,
        z=0.65,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE,
        x=0.0,
        y=-0.4,
        z=0.65,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.MOUTH,
        x=0.0,
        y=-0.4,
        z=0.65,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN,
        x=0.0,
        y=-0.4,
        z=0.65,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHEEK,
        x=0.0,
        y=-0.4,
        z=0.65,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu1.NECK,
        x=0.0,
        y=-0.4,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.FACE_MARKS,
        x=0.0,
        y=-0.4,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.HAIR,
        x=0.0,
        y=-0.4,
        z=0.7,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.BEARDS,
        x=0.0,
        y=-0.4,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP,
        x=0.0,
        y=-0.4,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.OLD_AGE,
        x=0.0,
        y=-0.4,
        z=0.6,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.TORSO,
        x=0.0,
        y=-1.6,
        z=0.3,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu2.BODY,
        x=0.0,
        y=-0.4,
        z=0.3,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu3.JACKET,
        x=0.0,
        y=-1.0,
        z=0.3,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu3.SHIRT,
        x=0.0,
        y=-1.0,
        z=0.3,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu3.LEGS,
        x=0.0,
        y=-0.8,
        z=-0.4,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu3.ACESSORY,
        x=0.0,
        y=-1.0,
        z=0.3,
    },
    {
        name = cAPI.getUILanguage(GetCurrentResourceName()).menu3.FOOTS,
        x=0.0,
        y=-0.8,
        z=-0.7,
    },
}

RegisterNetEvent('CKF_creator:createCharacter')
AddEventHandler('CKF_creator:createCharacter', function()
    createInitial(initialPosition)
    SetNuiFocus(true, true)
end)

-- Registers
RegisterNUICallback('Changes', function(data)
    local ped = PlayerPedId()
    if data.gender ~= nil and GetEntityModel(ped) ~= GetHashKey(data.gender) then
        if cAPI.setModel(data.gender) then
            Wait(10)
            defaultClothes(data.gender)
        end
    end
    if data.camera ~= nil then
        interpCamera(data.camera)
    end
    if data.changeAppearence  then
        SetPedHeadBlendData(ped, tonumber(data.mother), tonumber(data.father), nil, tonumber(data.shapeMother), tonumber(data.shapeFather), nil, tonumber(data.similarity), tonumber(data.skinSimilarity), nil, false)
    end
    if data.changeEye then
        print('data.eyeColors', data.eyeColors)
        SetPedFaceFeature(ped, 11, tonumber(data.eyeOpening))
        SetPedEyeColor(ped, tonumber(data.eyeColors))
        if data.eyebrows == 0 then SetPedHeadOverlay(ped, 2, 255) end -- remove eyebrows
        SetPedHeadOverlay(ped, 2, tonumber(data.eyebrows), tonumber(data.eyebrowsdensy))
        SetPedHeadOverlayColor(ped,2,1, tonumber(data.eyebrowscor), tonumber(data.eyebrowscor))
        SetPedFaceFeature(ped,6,tonumber(data.eyebrowsHeight))
        SetPedFaceFeature(ped,7,tonumber(data.eyebrowsWidth))
    end
    if data.changeNose then
        SetPedFaceFeature(ped,0,tonumber(data.noseWidth))
        SetPedFaceFeature(ped,1,tonumber(data.noseHeight))
        SetPedFaceFeature(ped,2,tonumber(data.noseLength))
        SetPedFaceFeature(ped,3,tonumber(data.noseBridge))
        SetPedFaceFeature(ped,4,tonumber(data.noseTip))
        SetPedFaceFeature(ped,5,tonumber(data.noseShift))
    end
    if data.changeChin then
        SetPedFaceFeature(ped,15,tonumber(data.chinLength))
        SetPedFaceFeature(ped,16,tonumber(data.chinPosition))
        SetPedFaceFeature(ped,17,tonumber(data.chinWidth))
        SetPedFaceFeature(ped,18,tonumber(data.chinShape))
        SetPedFaceFeature(ped,13,tonumber(data.jawWidth))
        SetPedFaceFeature(ped,14,tonumber(data.jawHeight))
    end
    if data.changeCheek then
        SetPedFaceFeature(ped,8,tonumber(data.cheekboneHeight))
        SetPedFaceFeature(ped,9,tonumber(data.cheekboneWidth))
        SetPedFaceFeature(ped,10,tonumber(data.cheeksWidth))
    end
    if data.changeLips then
	    SetPedFaceFeature(ped,12,tonumber(data.lips))
    end
    if data.changeNeck then
        SetPedFaceFeature(ped,19,tonumber(data.neckWidth))
    end
end)

RegisterNUICallback('StyleChange', function(data)
    local ped = PlayerPedId()
    if data.changeBrands then
        SetPedHeadOverlay(ped,6,tonumber(data.complexionModel),0.99)
        SetPedHeadOverlay(ped,7,tonumber(data.sundamageModel),0.99)
        SetPedHeadOverlay(ped,9,tonumber(data.frecklesModel),0.99)
    end
    if data.changeHair then
        SetPedComponentVariation(ped,2,tonumber(data.hairModel),0,0)
        SetPedHairColor(ped,tonumber(data.firstHairColor),tonumber(data.secondHairColor))
    end
    if data.changeBeard then
        SetPedHeadOverlay(ped,1,tonumber(data.beardModel),0.99)
        SetPedHeadOverlayColor(ped,1,1,tonumber(data.beardColor),tonumber(data.beardColor))
    end
    if data.changeMake then
        print('data.makeupModel', data.makeupModel)
        SetPedHeadOverlay(ped,5,tonumber(data.blushModel),0.99)
        SetPedHeadOverlayColor(ped,5,2,tonumber(data.blushColor),tonumber(data.blushColor))
        SetPedHeadOverlay(ped,8,tonumber(data.lipstickModel),0.99)
        SetPedHeadOverlayColor(ped,8,2,tonumber(data.lipstickColor),tonumber(data.lipstickColor))
        SetPedHeadOverlay(ped,4,tonumber(data.makeupModel),0.99)
        SetPedHeadOverlayColor(ped,4,0,0,0)
    end
    if data.changeOld then
        SetPedHeadOverlay(ped,3,tonumber(data.ageingModel),tonumber(data.ageingValue))
        SetPedHeadOverlayColor(ped,3,0,0,0)
    end
    if data.changeChest then
        SetPedHeadOverlay(ped,10,tonumber(data.chestModel),0.99)
        SetPedHeadOverlayColor(ped,10,1,tonumber(data.chestColor),tonumber(data.chestColor))
        SetPedComponentVariation(PlayerPedId(), 11, -1, 0, 2)
    end
    if data.changeBlemishes then
        SetPedHeadOverlay(ped,11,tonumber(data.blemishesModel),0.99)
        SetPedHeadOverlayColor(ped,11,0,0,0)
        SetPedHeadOverlay(ped,12,tonumber(data.blemishes2Model),0.99)
        SetPedHeadOverlayColor(ped,12,0,0,0)
        SetPedComponentVariation(PlayerPedId(), 11, -1, 0, 2)
    end
end)

RegisterNUICallback('ChangeClothes', function(data)
    local ped = PlayerPedId()
    if data.changeJacket then
        SetPedComponentVariation(ped, 11, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
    if data.changeShirt then
        SetPedComponentVariation(ped, 8, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
    if data.changeTorso then
        SetPedComponentVariation(ped, 3, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
    if data.changeLegs then
        SetPedComponentVariation(ped, 4, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
    if data.changeShoes then
        SetPedComponentVariation(ped, 6, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
    if data.changeAcessory then
        SetPedComponentVariation(ped, 7, tonumber(data.id), tonumber(data.texture), tonumber(data.texture))
    end
end)

fixedCam = nil
tempCam = nil
RegisterNUICallback('FinishedCreator', function(data)
    local ped = PlayerPedId()
    sendAll = {
        model = GetEntityModel(ped),
        headBlend = cAPI.GetPedHeadBlendData(),
        overlayHead = cAPI.GetHeadOverlayData(),
        headStruct = cAPI.GetHeadStructureData(),
        getHair = cAPI.GetPedHair()
    }
    clothes = {
        drawables = cAPI.GetDrawables(),
        drawTextures = cAPI.GetDrawTextures()
    }
    TriggerServerEvent('CKF_creator:saveCreator', data.charName, data.age, sendAll, clothes)
    ClearPedTasksImmediately(PlayerPedId())
    closeCreator()
    cAPI.CameraWithSpawnEffect(spawnAfterCreation)
end)

RegisterNUICallback('rotate', function(data, cb)
    if (data["key"] == "left") then
        rotation(20)
    else
        rotation(-20)
    end
    cb('ok') 
end)


-------------------
-----FUNCTIONS-----
-------------------
function interpCamera(cameraName)
    for k,v in pairs(cameraUsing) do
        if cameraUsing[k].name == cameraName then
            SetCamActiveWithInterp(fixedCam, tempCam, 1200, true, true)
            tempCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
            AttachCamToEntity(tempCam, PlayerPedId(), cameraUsing[k].x, cameraUsing[k].y, cameraUsing[k].z)
            SetCamActive(tempCam, true)
            SetCamActiveWithInterp(tempCam, fixedCam, 1200, true, true)
        end
    end
end

function createInitial(coords)
    SetNuiFocus(true, true) -- only dev
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
    -- create camera
   if cAPI.setModel('mp_m_freemode_01') then
        cAPI.EndFade(500)
        defaultClothes('mp_m_freemode_01')
        SetEntityVisible(PlayerPedId(),true)
        SetEntityAlpha(PlayerPedId(), 255)
        SetEntityHeading(PlayerPedId(), coords.h)
        loadAnimDict('mp_head_ik_override')
        TaskPlayAnim( PlayerPedId(), 'mp_head_ik_override', 'mp_creator_headik', 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
        createCamera()
    end
    SetEntityHeading(PlayerPedId(), coords.h)

    SetEntityHealth(GetPlayerPed(-1), 200)
    Citizen.Wait(1000)
    SetEntityHealth(GetPlayerPed(-1), 200)
    Citizen.Wait(2000)
    SetEntityHealth(GetPlayerPed(-1), 200)
    Citizen.Wait(3000)
    SetEntityHealth(GetPlayerPed(-1), 200)
end

function createCamera()
    groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    AttachCamToEntity(groundCam, PlayerPedId(), 0.5, -1.6, 0.0)
    SetCamRot(groundCam, 0, 0.0, 0.0)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    -- last camera, create interpolate
    fixedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    AttachCamToEntity(fixedCam, PlayerPedId(), 0.5, -1.6, 0.8)
    SetCamRot(fixedCam, -20.0, 0, 15.0)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 3900, true, true)
    Wait(3900)
    DestroyCam(groundCam)
    SendNUIMessage({
        action = "showCreator",
        menu1 = menu1, -- with i18n
        menu2 = menu2, -- with i18n
        menu3 = menu3, -- with i18n
    })
end

AddEventHandler(
    'onResourceStart',
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        closeCreator()
    end
)

function closeCreator()
    RenderScriptCams(false, false, 1, false, false)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeCreator'
    })
end

function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(PlayerPedId(), pedRot % 360)
end

function defaultClothes(gender)
    Citizen.CreateThread(function()
        if gender == "mp_m_freemode_01" then
            SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),2,2,1,2)
            SetPedComponentVariation(PlayerPedId(),7,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),3,15,0,2)
            SetPedComponentVariation(PlayerPedId(),4,15,0,2)
            SetPedComponentVariation(PlayerPedId(),8,15,0,2)
            SetPedComponentVariation(PlayerPedId(),6,35,0,2)
            SetPedComponentVariation(PlayerPedId(),11,5,0,2)
            SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),11,5,0,2)
            SetPedPropIndex(PlayerPedId(),2,-1,0,2)
            SetPedPropIndex(PlayerPedId(),6,-1,0,2)
            SetPedPropIndex(PlayerPedId(),7,-1,0,2)
        else
            SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),2,2,1,2)
            SetPedComponentVariation(PlayerPedId(),7,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),3,15,0,2)
            SetPedComponentVariation(PlayerPedId(),4,14,0,2)
            SetPedComponentVariation(PlayerPedId(),8,15,0,2)
            SetPedComponentVariation(PlayerPedId(),6,34,0,2)
            SetPedComponentVariation(PlayerPedId(),11,5,0,2)
            SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
            SetPedComponentVariation(PlayerPedId(),11,15,0,2)
            SetPedPropIndex(PlayerPedId(),2,-1,0,2)
            SetPedPropIndex(PlayerPedId(),6,-1,0,2)
            SetPedPropIndex(PlayerPedId(),7,-1,0,2)
        end
    end)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end