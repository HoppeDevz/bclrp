local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("delivery_milk")

hppC = {}
Tunnel.bindInterface("delivery_milk", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")


local cfg = module("delivery_milk", "config/cfg")

local InService = false
local Spot = 0
local AmountDelivery = 0
local blip

Citizen.CreateThread(function()
    while true do
        --for k,v in pairs(cfg) do
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = cfg.start[1], cfg.start[2], cfg.start[3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if not InService and distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"ENTREGAR LEITE",1.0,4,100)
                if IsControlJustPressed(0, 38) then
                    AmountDelivery = math.random(2, 10)
                    Spot = 1
                    InService = true

                    addServiceBlip( cfg.routes[Spot][1], cfg.routes[Spot][2], cfg.routes[Spot][3] )
                end
            end
        --end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if InService then
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local x2,y2,z2 = cfg.routes[Spot][1], cfg.routes[Spot][2], cfg.routes[Spot][3]

            local bowz,cdz = GetGroundZFor_3dCoord(x2,y2,z2)
            local distance = GetDistanceBetweenCoords(x2, y2, cdz,x,y,z,true)

            if distance < 20 then
                DrawMarker(20,x2,y2,z2,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(x2,y2,z2 + 0.6,"ENTREGAR LEITE",1.0,4,100)
                if distance < 1.5 then
                    if IsControlJustPressed(0, 38) then
                        local result = hpp.checkDelivery(AmountDelivery)
                        if not result.error then
                            if Spot == #cfg.routes then
                                Spot = 1
                                AmountDelivery = math.random(2, 10)
                                removeServiceBlip()

                                --notify("<b>~r~[AVISO] ~w~Você ganhou ~u~R$"..result.money_award.." ~w~de dinheiro sujo! </b>")
                                TriggerEvent("Notify", "sucesso", "Você ganhou ~u~R$"..result.money_award.." ~w~de dinheiro!")
                                addServiceBlip( cfg.routes[Spot][1], cfg.routes[Spot][2], cfg.routes[Spot][3] )
                            else
                                Spot = Spot + 1
                                AmountDelivery = math.random(2, 10)
                                removeServiceBlip()

                                --notify("<b>~r~[AVISO] ~w~Você ganhou ~u~R$"..result.money_award.." ~w~de dinheiro sujo! </b>")
                                TriggerEvent("Notify", "sucesso", "Você ganhou ~u~R$"..result.money_award.." ~w~de dinheiro!")
                                addServiceBlip( cfg.routes[Spot][1], cfg.routes[Spot][2], cfg.routes[Spot][3] )
                            end
                        else
                            --notify("<b>~r~[AVISO] ~w~Você não tem "..AmountDelivery.." leites! </b>")
                            TriggerEvent("Notify", "negado", "Você não tem "..AmountDelivery.." leites!")
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
        if InService then
            if IsControlJustPressed(0, 168) then
                InService = false
                Spot = 0
                AmountDelivery = 0

                removeServiceBlip()
                blip = nil
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(cfg) do
        if k == "start" then
            local workblip = AddBlipForCoord( v[1], v[2], v[3] )
            SetBlipSprite(workblip, 238)
            SetBlipColour(workblip, 4)
            SetBlipScale(workblip, 0.7)
            SetBlipAsShortRange(workblip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Central | Leiteiro")
            EndTextCommandSetBlipName(workblip)
        end
    end
end)

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

function addServiceBlip(_x, _y, _z)
    local x,y,z = _x, _y, _z
    blip = AddBlipForCoord(x, y, z)
end

function removeServiceBlip()
    RemoveBlip(blip)
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