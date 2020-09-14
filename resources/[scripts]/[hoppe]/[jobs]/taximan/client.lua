

local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("taximan")

hppC = {}
Tunnel.bindInterface("taximan", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")

cfg = module("taximan", "config/cfg")

local inService = false
local spotId = 0
local blip
local startRaceCoords
local RaceToCoords
local stagetwo = false

function ToogleTaxiMenu(_Promise)
    SetNuiFocus(_Promise, _Promise)
    if _Promise then
        SendNUIMessage({
            open = _Promise,
            spots = cfg.spots
        })
    else 
        SendNUIMessage({
            open = _Promise
        })
    end
end

RegisterCommand("taxiapp", function(source, args, rawCommand)
    ToogleTaxiMenu(true)
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 168) then
            inService = false
            spotId = 0
            startRaceCoords = nil
            RaceToCoords = nil
            stagetwo = false

            RemoveBlip(blip)
            blip = nil
        end
        Citizen.Wait(1)
    end
end)

RegisterNUICallback("closeMenu", function()
    ToogleTaxiMenu(false)
end)

RegisterNUICallback("startRace", function(id)
    if inService then
        return TriggerEvent("Notify", "negado", "Você já está em uma rota!")
    end

    inService = true
    spotId = tonumber(id)

    for k,v in pairs(cfg.spots) do
        print(k)
        if k == spotId then
            startRaceCoords =  { v.x, v.y, v.z }
            RaceToCoords = { v.xp, v.yp, v.zp }
            blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip,198)
            SetBlipAsShortRange(blip,true)
            SetBlipColour(blip,28)
            SetBlipScale(blip,0.7)

            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 28)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("CLIENTE | TAXI")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if inService then
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) ) 
            local x2,y2,z2 = startRaceCoords[1], startRaceCoords[2], startRaceCoords[3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)
            
            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"CLIENTE | TAXI",1.0,4,100)
                if distance < 1.5 and IsControlJustPressed(0, 38) then
                    inService = false
                    RemoveBlip(blip)
                    stagetwo = true

                    -- create stagetwo blip
                    blip = AddBlipForCoord(RaceToCoords[1], RaceToCoords[2], RaceToCoords[3])
                    SetBlipSprite(blip,198)
                    SetBlipAsShortRange(blip,true)
                    SetBlipColour(blip,28)
                    SetBlipScale(blip,0.7)

                    SetBlipRoute(blip, true)
                    SetBlipRouteColour(blip, 28)

                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("DESTINO | CLIENTE")
                    EndTextCommandSetBlipName(blip)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if stagetwo then
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) ) 
            local x2,y2,z2 = RaceToCoords[1], RaceToCoords[2], RaceToCoords[3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"DESTINO | CLIENTE",1.0,4,100)
                if distance < 1.5 and IsControlJustPressed(0,38) then
                    --give money (server side)
                    

                    inService = false
                    spotId = 0
                    startRaceCoords = nil
                    RaceToCoords = nil
                    stagetwo = false

                    RemoveBlip(blip)
                    blip = nil
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack( GetEntityCoords(ped) )
        local x2,y2,z2 = cfg.start_mission[1], cfg.start_mission[2], cfg.start_mission[3]

        local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
        local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

        if distance < 20 then
            DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
            DrawText3D(x2,y2,z2 + 0.6,"CENTRAL | TAXISTA",1.0,4,100)
            if distance < 1.5 and IsControlJustPressed(0, 38) then
                ToogleTaxiMenu(true)
            end
        end

        Citizen.Wait(1)
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