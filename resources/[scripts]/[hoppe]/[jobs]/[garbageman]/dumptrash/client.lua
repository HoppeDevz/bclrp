local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("dumptrash")

hppC = {}
Tunnel.bindInterface("dumptrash", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")

local cfg = module("dumptrash", "config/cfg")

function ToogleDumpTrashNUI(_Promise)
    if _Promise then
        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    SetNuiFocus(_Promise, _Promise)
    SendNUIMessage({
        open = _Promise
    })
end

RegisterNUICallback("closeMenu", function()
    ToogleDumpTrashNUI(false)
end)

RegisterNUICallback("dump", function(_Quantity)
    local result = hpp.dumptrash(_Quantity)
    if not result.error then
        notify('<b>~r~[AVISO] ~w~Você ganhou ~g~R$'..result.amount..'</b>')
    else
        notify('<b>~r~[AVISO] ~w~Você não possui esta quantidade de lixo!</b>')
    end
end)

local refresh_time_dumptrash = 3000
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack( GetEntityCoords(ped) )
        local x2,y2,z2 = cfg.dumpSpot[1], cfg.dumpSpot[2], cfg.dumpSpot[3]

        local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
        local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

        if distance < 20 then
            refresh_time_dumptrash = 1
            DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
            DrawText3D(x2,y2,z2 + 0.6,"DESPEJAR | LIXO",1.0,4,100)
            if distance < 1.5 and IsControlJustPressed(0, 38) then
                ToogleDumpTrashNUI(true)
            end
        else
            refresh_time_dumptrash = 3000
        end
        Citizen.Wait(refresh_time_dumptrash)
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