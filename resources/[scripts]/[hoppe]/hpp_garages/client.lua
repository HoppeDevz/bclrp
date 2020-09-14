local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_garages")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5 * 60 * 1000)
        collectgarbage("count")
        collectgarbage("collect")
    end
end)

local garages = {
    [1] = { ["x"] = 55.43, ["y"] = -876.19, ["z"] = 30.66, ["x2"] = 44.20, ["y2"] = -870.47, ["z2"] = 30.46, ["h"] = 160.0 },
    [2] = { ["x"] = 317.25, ["y"] = 2623.14, ["z"] = 44.46, ["x2"] = 334.52, ["y2"] = 2623.09, ["z2"] = 44.49, ["h"] = 20.0 },
    [3] = { ["x"] = -1169.57, ["y"] = -1761.79, ["z"] = 4.21, ["x2"] = -1154.06, ["y2"] = -1747.95, ["z2"] = 4.04, ["h"] = 28.73 },
    [4] = { ["x"] = -773.34, ["y"] = 5598.15, ["z"] = 33.60, ["x2"] = -772.82, ["y2"] = 5578.48, ["z2"] = 33.48, ["h"] = 89.0 },
    [5] = { ["x"] = 275.23, ["y"] = -345.54, ["z"] = 45.17, ["x2"] = 285.05, ["y2"] = -339.29, ["z2"] = 44.91, ["h"] = 249.0 },
    [6] = { ["x"] = 596.40, ["y"] = 90.65, ["z"] = 93.12, ["x2"] = 608.21, ["y2"] = 104.11, ["z2"] = 92.81, ["h"] = 70.0 },
    [7] = { ["x"] = -340.76, ["y"] = 265.97, ["z"] = 85.67, ["x2"] = -328.80, ["y2"] = 277.92, ["z2"] = 86.34, ["h"] = 95.0 },
    [8] = { ["x"] = -2030.01, ["y"] = -465.97, ["z"] = 11.60, ["x2"] = -2024.27, ["y2"] = -471.93, ["z2"] = 11.40, ["h"] = 140.0 },
    [9] = { ["x"] = -1184.92, ["y"] = -1510.00, ["z"] = 4.64, ["x2"] = -1186.70, ["y2"] = -1490.54, ["z2"] = 4.37, ["h"] = 125.0 },
    [10] = { ["x"] = -73.44, ["y"] = -2004.99, ["z"] = 18.27, ["x2"] = -84.96, ["y2"] = -2004.22, ["z2"] = 18.01, ["h"] = 352.0 },
    [11] = { ["x"] = 214.02, ["y"] = -808.44, ["z"] = 31.01, ["x2"] = 227.62, ["y2"] = -789.23, ["z2"] = 30.68, ["h"] = 247.0 },
    [12] = { ["x"] = -348.88, ["y"] = -874.02, ["z"] = 31.31, ["x2"] = -334.58, ["y2"] = -891.73, ["z2"] = 31.07, ["h"] = 345.0 },
    [13] = { ["x"] = 67.74, ["y"] = 12.27, ["z"] = 69.21, ["x2"] = 57.63, ["y2"] = 18.25, ["z2"] = 69.29, ["h"] = 339.38 },
    [14] = { ["x"] = 361.90, ["y"] = 297.81, ["z"] = 103.88, ["x2"] = 371.18, ["y2"] = 284.78, ["z2"] = 103.25, ["h"] = 338.86 },
    [15] = { ["x"] = -2676.17, ["y"] = 1307.54, ["z"] = 147.16, ["x2"] = -2663.81, ["y2"] = 1308.32, ["z2"] = 147.11, ["h"] = 268.74 }
}

local currentGarageSpawn
local currentCar = ""
local currentCarName = ""

local blip

local LockIdle = 3000

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if currentCar ~= "" then
            if DoesEntityExist(currentCar) then

                LockIdle = 1

                local v = GetVehiclePedIsIn(GetPlayerPed(-1))   
                if v == currentCar then
                    SetBlipAlpha(blip, 0)
                else
                    SetBlipAlpha(blip, 255)
                end

                if blip then
                    local x,y,z = table.unpack( GetEntityCoords(currentCar) )
                    SetBlipCoords(blip, x,y,z)
                end 

            else
                LockIdle = 3000
                currentCar = ""
                currentCarName = ""
            end
        end
    end
end)

Citizen.CreateThread(function() SetNuiFocus(false, false) end )

function ToogleGarageMenu(_promise)
    if _promise then
        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    SetNuiFocus(_promise, _promise)
    SendNUIMessage({
        open = _promise,
        vehicles = hpp.getAllVehicles()
    })
end

RegisterNUICallback("closeMenu", function()
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    ToogleGarageMenu(false)
end)

RegisterNUICallback("despawnCar", function(data)
    if blip then RemoveBlip(blip) end  
    DeleteEntity(currentCar)
    currentCar = ""
    --notify("<b>~r~[AVISO] ~w~Carro guardado com sucesso! ~y~["..string.upper(currentCarName).."]</b>")
    TriggerEvent("Notify", "sucesso", "Carro guardado com sucesso! ["..string.upper(currentCarName).."]")
end)

RegisterNUICallback("spawnCar", function(data)
    PlaySoundFrontend(-1, "MP_AWARD", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

    if currentCar == "" then
        local custom = hpp.getMods(data.plate)
        hpp_spawnCar(data.vehicle, data.plate, currentGarageSpawn.x,currentGarageSpawn.y,currentGarageSpawn.z, currentGarageSpawn.h, custom)

        local x,y,z = table.unpack( GetEntityCoords(currentCar) )
        blip = AddBlipForCoord( x,y,z )

        SetBlipSprite(blip, 326)
        SetBlipColour(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Veículo Pessoal")
        EndTextCommandSetBlipName(blip)

        currentCarName = data.vehicle
    else
        --notify("<b>~r~[AVISO] ~w~VOCÊ JÁ POSSUI UM CARRO FORA DA GARAGEM!</b>")
        TriggerEvent("Notify", "negado", "VOCÊ JÁ POSSUI UM CARRO FORA DA GARAGEM!")
    end
end)

local near_garages = {}
local GarageIdle = 3000
local NearGarage = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(GarageIdle)
        for i = 1,#garages do
            if i == 1 then NearGarage = false end
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )

            local bowz,cdz = GetGroundZFor_3dCoord(garages[i].x, garages[i].y, garages[i].z)
            local distance = GetDistanceBetweenCoords(garages[i].x, garages[i].y,cdz,x,y,z,true)

            if distance < 20 then
                NearGarage = true
                DrawMarker(36,garages[i].x, garages[i].y, garages[i].z,0,0,0,0,0,0,1.0,1.0,1.0,0,0,150,50,1,1,1,1)
                if distance < 1.5 then
                    if IsControlJustPressed(0, 38) then
                        currentGarageSpawn = { ["x"] = garages[i].x2, ["y"] = garages[i].y2, ["z"] = garages[i].z2, ["h"] = garages[i].h }
                        ToogleGarageMenu(true)
                    end
                end
            end
        end

        if NearGarage then
            GarageIdle = 1
        else
            GarageIdle = 3000
        end
    end
end)

function hpp_spawnCar(vehicle, plate, x,y,z,h, custom)
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

        if custom then
            setVehMods(custom,NetToVeh(netveh))
        end

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

function setVehMods(custom, veh)
    if not veh then
		veh = GetVehiclePedIsUsing(PlayerPedId())
	end
	if custom and veh then
		SetVehicleModKit(veh,0)
		if custom.colour then
			SetVehicleColours(veh,tonumber(custom.colour.primary),tonumber(custom.colour.secondary))
			SetVehicleExtraColours(veh,tonumber(custom.colour.pearlescent),tonumber(custom.colour.wheel))
			if custom.colour.neon then
				SetVehicleNeonLightsColour(veh,tonumber(custom.colour.neon[1]),tonumber(custom.colour.neon[2]),tonumber(custom.colour.neon[3]))
			end
			if custom.colour.smoke then
				SetVehicleTyreSmokeColor(veh,tonumber(custom.colour.smoke[1]),tonumber(custom.colour.smoke[2]),tonumber(custom.colour.smoke[3]))
			end
			if custom.colour.custom then
				if custom.colour.custom.primary then
					SetVehicleCustomPrimaryColour(veh,tonumber(custom.colour.custom.primary[1]),tonumber(custom.colour.custom.primary[2]),tonumber(custom.colour.custom.primary[3]))
				end
				if custom.colour.custom.secondary then
					SetVehicleCustomSecondaryColour(veh,tonumber(custom.colour.custom.secondary[1]),tonumber(custom.colour.custom.secondary[2]),tonumber(custom.colour.custom.secondary[3]))
				end
			end
		end

		if custom.plate then
			SetVehicleNumberPlateTextIndex(veh,tonumber(custom.plate.index))
		end

		SetVehicleWindowTint(veh,tonumber(custom.janela))
		SetVehicleTyresCanBurst(veh,tonumber(custom.bulletproof))
		SetVehicleWheelType(veh,tonumber(custom.wheel))

		ToggleVehicleMod(veh,18,tonumber(custom.turbo))
		ToggleVehicleMod(veh,20,tonumber(custom.fumaca))
		ToggleVehicleMod(veh,22,tonumber(custom.farol))

		if custom.neon then
			SetVehicleNeonLightEnabled(veh,0,tonumber(custom.neon.left))
			SetVehicleNeonLightEnabled(veh,1,tonumber(custom.neon.right))
			SetVehicleNeonLightEnabled(veh,2,tonumber(custom.neon.front))
			SetVehicleNeonLightEnabled(veh,3,tonumber(custom.neon.back))
		end

		for i,mod in pairs(custom.mods) do
			if i ~= 18 and i ~= 20 and i ~= 22 and i ~= 46 then
				SetVehicleMod(veh,tonumber(i),tonumber(mod))
			end
		end
		SetVehicleMod(veh,23,tonumber(custom.tyres),custom.tyresvariation)
		SetVehicleMod(veh,24,tonumber(custom.tyres),custom.tyresvariation)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(LockIdle)
        if IsControlJustPressed(0, 182) then
            if currentCar ~= "" then
                animApi.playAnim(true,{{"anim@mp_player_intmenu@key_fob@","fob_click_fp"}},false)
                TriggerServerEvent("garages-tryLock", VehToNet(currentCar))
                local locked = GetVehicleDoorLockStatus(currentCar) 
                if locked == 1 then
                    TriggerEvent("Notify", "importante", "Veículo trancado!")
                else
                    TriggerEvent("Notify", "importante", "Veículo destrancado!")
                end
                TriggerEvent("vrp_sound:source", 'lock', 0.5)
            end
        end
    end
end)

RegisterNetEvent("garages-syncLock")
AddEventHandler("garages-syncLock",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				local locked = GetVehicleDoorLockStatus(v)
                if locked == 1 then
                    --notify("<b>~r~[AVISO] ~w~Veículo trancado!</b>")
                    --TriggerEvent("Notify", "importante", "Veículo trancado!")
					SetVehicleDoorsLocked(v,2)
                else
                    --notify("<b>~r~[AVISO] ~w~Veículo destrancado!</b>")
                    --TriggerEvent("Notify", "importante", "Veículo destrancado!")
					SetVehicleDoorsLocked(v,1)
				end
				SetVehicleLights(v,2)
				Wait(200)
				SetVehicleLights(v,0)
				Wait(200)
				SetVehicleLights(v,2)
				Wait(200)
				SetVehicleLights(v,0)
			end
		end
	end
end)

RegisterNetEvent("garages-syncUnLock")
AddEventHandler("garages-syncUnLock",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				local locked = GetVehicleDoorLockStatus(v)
                --notify("<b>~r~[AVISO] ~w~Veículo destrancado!</b>")
                TriggerEvent("Notify", "importante", "Veículo destrancado!")
				SetVehicleDoorsLocked(v,1)
			end
		end
	end
end)