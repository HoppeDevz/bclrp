local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("garbageman")

hppC = {}
Tunnel.bindInterface("garbageman", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")


local cfg = module("garbageman", "config/cfg")

local inService = false
local spotId = 0
local blip
local garbagetruck

function ToogleGarbageManNUI(_Promise)
    SetNuiFocus(_Promise, _Promise)
    if _Promise then
        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        SendNUIMessage({
            open = _Promise,
            service = inService
        })
    else
        SendNUIMessage({
            open = _Promise
        })
    end
end

RegisterNUICallback("closeMenu", function()
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    ToogleGarbageManNUI(false)
end)

RegisterNUICallback("startWork", function()
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    if not inService then
        spotId = 1
        inService = true

        garbagetruck = hpp_spawnCar("trash", "ALUGUEL", -621.60101318359,-1595.6672363281,26.751012802124, 100.00)
        NetworkFadeOutEntity(garbagetruck, true, true)
        NetworkFadeInEntity(garbagetruck, 1)

        blip = AddBlipForCoord(cfg.spots[spotId].x, cfg.spots[spotId].y, cfg.spots[spotId].z)
        SetBlipSprite(blip,318)
        SetBlipAsShortRange(blip,true)
        SetBlipColour(blip,25)
        SetBlipScale(blip,0.7)

        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 25)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("COLETAR | LIXO")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNUICallback("stopWork", function()
     PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
     inService = false
     spotId = 0

     NetworkFadeOutEntity(garbagetruck, false, true)
     Citizen.Wait(900)
     DeleteEntity(garbagetruck)  
     garbagetruck = nil

     RemoveBlip(blip)
     blip = nil
end)

local refresh_time_startjob = 3000
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack( GetEntityCoords(ped) )
        local x2,y2,z2 = cfg.start_mission[1], cfg.start_mission[2], cfg.start_mission[3]

        local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
        local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)
        if distance < 20 then
            refresh_time_startjob = 1
            DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
            DrawText3D(x2,y2,z2 + 0.6,"CENTRAL | LIXEIRO",1.0,4,100)
            if distance < 1.5 and IsControlJustPressed(0, 38) then
                ToogleGarbageManNUI(true)
            end
        else
            refresh_time_startjob = 3000
        end
        Citizen.Wait(refresh_time_startjob)
    end
end)

local refresh_time_inService = 3000
Citizen.CreateThread(function()
    while true do
        if inService then
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = cfg.spots[spotId].x, cfg.spots[spotId].y, cfg.spots[spotId].z

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if distance < 20 then
                refresh_time_inService = 1
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,200,0,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"COLETAR | LIXO",1.0,4,100)
                if distance < 1.5 and IsControlJustPressed(0, 38) then
                    if not IsPedInAnyVehicle(ped) then
                        --give trash item
                        local result = hpp.giveTrashItem()
                        if not result.error then 
                        
                            if spotId < 38 then
                                spotId = spotId + 1
                                RemoveBlip(blip)

                                blip = AddBlipForCoord(cfg.spots[spotId].x, cfg.spots[spotId].y, cfg.spots[spotId].z)
                                SetBlipSprite(blip,318)
                                SetBlipAsShortRange(blip,true)
                                SetBlipColour(blip,25)
                                SetBlipScale(blip,0.7)
                            
                                SetBlipRoute(blip, true)
                                SetBlipRouteColour(blip, 25)
                            
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("COLETAR | LIXO")
                                EndTextCommandSetBlipName(blip)
                            else
                                spotId = 1
                            end
                        
                        else
                            notify('<b>~r~[AVISO] ~w~Você não tem espaço na mochila!</b>')
                        end
                    end
                end
            else
                refresh_time_inService = 3000
            end
        else
            refresh_time_inService = 3000
        end
        Citizen.Wait(refresh_time_inService)
    end
end)

function DrawText3D(x,y,z, text, scl, font, opacity) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
   
	if onScreen then
		SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, opacity)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end

function hpp_spawnCar(vehicle, plate, x,y,z,h)
    local mhash = GetHashKey(vehicle)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(1)
    end

    if HasModelLoaded(mhash) then
        local nveh = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
        local netveh = VehToNet(nveh)
        local id = NetworkGetNetworkIdFromEntity(nveh)

        NetworkRegisterEntityAsNetworked(nveh)
        while not NetworkGetEntityIsNetworked(nveh) do
            NetworkRegisterEntityAsNetworked(nveh)
            Citizen.Wait(1)
        end

        if NetworkDoesNetworkIdExist(netveh) then
            SetEntitySomething(nveh,true)
            if NetworkGetEntityIsNetworked(nveh) then
                SetNetworkIdExistsOnAllMachines(netveh,true)
            end
        end

        --if custom then
            --vRPg.setVehicleMods(custom,NetToVeh(netveh))
        --end

        SetNetworkIdCanMigrate(id,true)
        SetVehicleNumberPlateText(NetToVeh(netveh),plate)
        Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
        SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
        SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
        SetModelAsNoLongerNeeded(mhash)
        SetVehRadioStation(NetToVeh(netveh),"OFF")

        --SetVehicleEngineHealth(NetToVeh(netveh),enginehealth+0.0)
        --SetVehicleBodyHealth(NetToVeh(netveh),bodyhealth+0.0)
        --SetVehicleFuelLevel(NetToVeh(netveh),fuellevel+0.0)

        --vehicles[name] = { name,nveh }

        --return true,VehToNet(nveh),name

        currentCar = nveh
        return nveh
    end
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