local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("trucker")

hppC = {}
Tunnel.bindInterface("trucker", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")


local cfg = module("trucker", "config/cfg")

local inDelivery = false
local DeliverySpot
local blip
local currentTrucker
local currentTruck

function ToogleTrukcerMenu(_Promise)
    SetNuiFocus(_Promise, _Promise)
    if _Promise then
        SendNUIMessage({
            open = _Promise,
            data = cfg.start.data
        })
    else
        SendNUIMessage({
            open = _Promise
        })
    end
end

--Citizen.CreateThread(function()
    --SetNuiFocus(false,false)
    --DoScreenFadeIn(1000)
--end)

RegisterNUICallback("closeMenu", function()
    ToogleTrukcerMenu(false)
end)

RegisterNUICallback("startDelivery", function(data)
    if not inDelivery then
        print(data.truck)
        DeliverySpot = data.delivery_point

        if not currentTruck then
            currentTruck = hpp_spawnCar(data.truck, "ALUGUEL", data.truck_spawn[1], data.truck_spawn[2], data.truck_spawn[3], data.truck_spawn[4])
        end

        if not currentTrucker then
            currentTrucker = hpp_spawnCar(data.trucker, "ALUGUEL", data.trucker_spawn[1], data.trucker_spawn[2], data.trucker_spawn[3], data.trucker_spawn[4])
        end

        blip = AddBlipForCoord(data.delivery_point[1], data.delivery_point[2], data.delivery_point[3])
		SetBlipSprite(blip,162)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,4)
        SetBlipScale(blip,0.7)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Entrega")
        EndTextCommandSetBlipName(blip)
        
        inDelivery = true

        TriggerEvent("trucker:tutorial:notify")
    end
end) 

RegisterNetEvent("trucker:tutorial:notify")
AddEventHandler("trucker:tutorial:notify", function()
    --notify("<b>~r~[AVISO] ~w~AO APERTAR F7 VOCÊ CANCELA SEU TRABALHO</b>")
    TriggerEvent("Notify", "importante", "AO APERTAR F7 VOCÊ CANCELA SEU TRABALHO")
end)

Citizen.CreateThread(function()
    for k,v in pairs(cfg.blip) do
        local blipwork = AddBlipForCoord(v._coords[1], v._coords[2], v._coords[3])
        SetBlipSprite(blipwork,v._blipSprite)
		SetBlipAsShortRange(blipwork,true)
		SetBlipColour(blipwork,v._blipColor)
        SetBlipScale(blipwork,0.7)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(k)
        EndTextCommandSetBlipName(blipwork)
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 168) then

            if inDelivery then

                DoScreenFadeOut(1000)
                Citizen.Wait(1000)
                DeleteEntity(currentTrucker)
                DeleteEntity(currentTruck)

                inDelivery = false
                DeliverySpot = nil
                currentTrucker = nil
                currentTruck = nil

                RemoveBlip(blip)
                blip = nil

                local ped = GetPlayerPed(-1)
                SetEntityCoords(ped, -139.819, -2385.119, 6.000)
                DoScreenFadeIn(1000)
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if inDelivery then
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = DeliverySpot[1], DeliverySpot[2], DeliverySpot[3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"ENTREGA",1.0,4,100)
                if distance < 1.5 then
                    if IsControlJustPressed(0, 38) then
                        RemoveBlip(blip)
                        if currentTrucker then
                            local x0,y0,z0 = -139.819, -2385.119, 6.000
                            local bowz2,cdz2 = GetGroundZFor_3dCoord(x2,y2,z2)
                            local distance2 = GetDistanceBetweenCoords(x2, y2, cdz,x0,y0,z0,true)

                            local rewardAmount = hpp.checkReward(distance2)
                            notify("<b>~r~[AVISO] ~w~Você ganhou ~g~R$"..rewardAmount.."</b>")
                            TriggerEvent("Notify", "sucesso", "Você ganhou ~g~R$"..rewardAmount)
                            DeleteEntity(currentTrucker)   
                            currentTrucker = nil

                            inDelivery = false
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
        for k,v in pairs(cfg.start) do
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = v[1], v[2], v[3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"CAMINHONEIRO",1.0,4,100)
                if distance < 1.5 then
                    if IsControlJustPressed(0, 38) then
                        ToogleTrukcerMenu(true)
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

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