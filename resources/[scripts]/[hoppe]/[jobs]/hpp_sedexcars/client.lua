local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_sedexcars")

hppC = {}
Tunnel.bindInterface("hpp_sedexcars", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local cfg = module("hpp_sedexcars", "config/cfg")

animApi = module("_core", "client/functions/_Anims")

local nearvankey = ""
local isnearvan = false
local boxamount = 0
local Working = false
local spotId = 0

local blip

local carrybox = false

local PickUpBoxesSpot = { 78.900978088379,111.81643676758,81.16822052002 }
local StartJob = { 66.008850097656,125.28760528564,79.165557861328 }

Citizen.CreateThread(function()
    local workblip = AddBlipForCoord(StartJob[1], StartJob[2], StartJob[3])
    SetBlipSprite(workblip,478)
    SetBlipAsShortRange(workblip,true)
    SetBlipColour(workblip,28)
    SetBlipScale(workblip,0.7)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Central | SEDEX")
    EndTextCommandSetBlipName(workblip)
end)

Citizen.CreateThread(function()
    while true do
        local veh = getNearestVehicle(6)
        if veh == nil or veh == "" then
            isnearvan = false
        end
        if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "BOXVILLE" then
            local result = hpp.checkExistVan(veh)
            if not result.exist then
                hpp.registerCar(veh)
                nearvankey = veh
                isnearvan = true
            else
                isnearvan = true
                nearvankey = veh
                boxamount = result.BoxNumber
            end
        else
            isnearvan = false
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isnearvan then
            drawTxt("VOCÊ ESTÁ PERTO DE UMA VAN DO SEDEX!",4,0.50,0.90,0.56,255,255,255,240)
            drawTxt("CARREGADO COM ~b~"..boxamount.."~w~ CAIXAS",4,0.50,0.93,0.56,255,255,255,240)
            if carrybox then
                if IsControlJustPressed(0, 38) then
                    animApi.DeletarObjeto()
                    hpp.updateboxamount(nearvankey, 1)
                    carrybox = false
                end
            else
                if IsControlJustPressed(0, 38) then
                    if parseInt(hpp.getBoxAmount(nearvankey)) > 0 then
                        hpp.updateboxamount(nearvankey, -1)
                        animApi.CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",49,28422)
                        carrybox = true
                    else
                        --notify("<b>~r~[AVISO] ~w~A van está vazia! </b>")
                        TriggerEvent("Notify", "negado", "A van está vazia!")
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x1,y1,z1 = PickUpBoxesSpot[1], PickUpBoxesSpot[2], PickUpBoxesSpot[3]
        local x2,y2,z2 = table.unpack( GetEntityCoords(ped) )

        local distance = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true)

        if distance < 20 and not carrybox then
            DrawMarker(20,x1,y1,z1,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
            if not isnearvan then
                if distance < 2 then
                    drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR UMA CAIXA",4,0.50,0.93,0.56,255,255,255,240)
                    if IsControlJustPressed(0, 38) then
                        --playanim
                        animApi.CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",49,28422)
                        carrybox = true
                    end
                end
            else
                if distance < 2 then
                    drawTxt("LEVE SUA VAN PARA MAIS LONGE!",4,0.50,0.86,0.56,255,255,255,240)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if carrybox then
            if IsControlJustPressed(0, 167) then
                --stopanim
                animApi.DeletarObjeto()
                carrybox = false
            end
        end
        Citizen.Wait(1)
    end
end)

--START JOB
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x1,y1,z1 = table.unpack( GetEntityCoords(ped) )
        local x2,y2,z2 = StartJob[1], StartJob[2], StartJob[3]
        local distance = GetDistanceBetweenCoords(x1,y1,z1, x2,y2,z2, true)

        if distance < 20 and not Working then
            DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
            if distance < 2 then
                drawTxt("PRESSIONE ~b~E~w~ PARA TRABALHAR",4,0.50,0.87,0.56,255,255,255,240)
                if IsControlJustPressed(0, 38) then
                    Working = true
                    spotId = 1
                    --addblip
                    addblip()
                    --notify("<b>~r~[AVISO] ~w~Você entrou em serviço!</b>")
                    TriggerEvent("Notify", "importante", "Você entrou em serviço!")
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Working then
            local ped = GetPlayerPed(-1)
            local x1,y1,z1 = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = cfg.locs[spotId].x, cfg.locs[spotId].y, cfg.locs[spotId].z
            local distance = GetDistanceBetweenCoords(x1,y1,z1, x2,y2,z2, true)
            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                if distance < 2 then
                    if not isnearvan then
                        if IsControlJustPressed(0, 38) then
                            if carrybox then
                                local amount = hpp.givereward()
                                --notify("<b>~r~[AVISO] ~w~Você ganhou ~g~R$"..amount.."</b>")
                                TriggerEvent("Notify", "sucesso", "Você ganhou ~g~R$"..amount)
                                animApi.DeletarObjeto()
                                carrybox = false

                                --removeblip
                                removeblip()

                                if spotId < 38 then
                                    spotId = spotId + 1
                                else
                                    spotId = 1
                                end

                                addblip()

                            else
                                --notify("<b>~r~[AVISO] ~w~Você deve pegar uma caixa na van!</b>")
                                TriggerEvent("Notify", "negado", "Você deve pegar uma caixa na van!")
                            end
                        end
                    else
                        if distance < 4 then
                            drawTxt("LEVE SUA VAN PARA MAIS LONGE!",4,0.50,0.86,0.56,255,255,255,240)
                        end
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Working then
            if IsControlJustPressed(0, 168) then
                removeblip()
                spotId = 0
                blip = nil

                Working = false
            end
        end
        Citizen.Wait(1)
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function getAllVehicles()
	local vehs = {}
	local it, veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
		EndFindVehicle(it)
	return vehs
end

function getNearestVehicles(radius)
	local r = {}
	local px,py,pz = table.unpack( GetEntityCoords(GetPlayerPed(-1)) )
	for _,veh in pairs(getAllVehicles()) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end

function getNearestVehicle(radius)
	local veh
	local vehs = getNearestVehicles(radius)
	local min = radius+0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh
end

function newNotify(entry, color, elements, sound)
    if (color ~= -1) then
        SetNotificationBackgroundColor(color)
    end
    SetNotificationTextEntry(entry)
    for _, element in ipairs(elements) do
            AddTextComponentSubstringPlayerName(element)
    end
    DrawNotification(false, false)
    if (sound) then
            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
    end
end

function notify(msg)
	newNotify("STRING", 11, {"" .. msg}, true)
end

function addblip()
    blip = AddBlipForCoord(cfg.locs[spotId].x, cfg.locs[spotId].y, cfg.locs[spotId].z)
    SetBlipSprite(blip,478)
    SetBlipAsShortRange(blip,true)
    SetBlipColour(blip,28)
    SetBlipScale(blip,0.7)

    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 28)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("ENTREGAR | ENCOMENDA")
    EndTextCommandSetBlipName(blip)
end

function removeblip()
    RemoveBlip(blip)
    blip = nil
end