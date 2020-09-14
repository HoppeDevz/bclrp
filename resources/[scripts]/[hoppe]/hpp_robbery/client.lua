local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_robbery")

hppC = {}
Tunnel.bindInterface("hpp_robbery", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

animApi = module("_core", "client/functions/_Anims")
cfg = module("hpp_robbery", "config/robbery")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5 * 60 * 1000)
        collectgarbage("count")
        collectgarbage("collect")
    end
end)

local roubando = false
local counter = 0
local cancel_action = false

local current_robbery_coords = {}
local current_robbery_id = 0


local near_robbery = false
local near_robbery_idle = 3000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(near_robbery_idle)
        for _, item in pairs(cfg.spots) do
            if _ == 1 then near_robbery = false end
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack( GetEntityCoords(ped) )
            local distance = GetDistanceBetweenCoords(x,y,z, item.x, item.y, item.z, true)

            if distance < 10 then
                near_robbery = true
                DrawMarker(20,item.x, item.y, item.z,0,0,0,0,0,0,0.5,0.5,0.5,0,150,150,50,1,1,1,1)
                DrawText3D(item.x, item.y, item.z + 0.6,"CAIXINHA",1.0,4,100)
                if not roubando and distance < 0.9 then
                    drawTxt("APERTE ~r~E~w~ PARA ROUBAR",4,0.5,0.91,0.36,255,255,255,200)
                    if IsControlJustPressed(0, 38) then
                        if exports.hpp_toogle.GetCopsToogled() < 2 then
                            TriggerEvent("Notify", "negado", "Número insuficiente de policiais!")
                        else
                            if hpp.checkPerm("policePerm") then
                                TriggerEvent("Notify", "negado", "Você é um policial!")
                            else

                                if not hpp.getRobberyStatus() then
                                    TriggerServerEvent(
                                    "hoppe:robbery:sendCopsNotification", 
                                    item.x,  
                                    item.y,
                                    item.z,
                                    "<b>[AVISO] Sujeito suspeito iniciou um assalto, marcamos o local em seu mapa!</b>"
                                    )
                                    hpp.setRobberyStatus(true)

                                    current_robbery_coords = { item.x, item.y, item.z }
        
                                    TriggerEvent('cancelando', true)
                                    SetEntityCoords(GetPlayerPed(-1), item.x, item.y, item.z)
                                    SetEntityHeading(GetPlayerPed(-1), item.h)
                                    animApi.playAnim(false, {{ "anim@heists@ornate_bank@grab_cash_heels", "grab" }}, true)
                                    roubando = true
                                    if item.id < 13 then
                                        counter = 60
                                    end
                                    
                                    if item.id > 26 and item.id < 42 then
                                        counter = 20
                                    else
                                        counter = 190
                                    end

                                    current_robbery_id = item.id
                                else
                                    -- notify("<b>~r~[AVISO] ~w~Já existe um roubo em andamento, tente mais tarde!</b>")
                                    TriggerEvent("Notify", "negado", "Já existe um roubo em andamento, tente mais tarde!")
                                end
                            end
                        end
                    end
                end

            end
        end

        if near_robbery then
            near_robbery_idle = 1
        else 
            near_robbery_idle = 3000
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('cancelando', false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(near_robbery_idle)
        if roubando then
            counter = counter - 1
            Citizen.Wait(1000)

            if counter == 0 then
                roubando = false

                if cancel_action then
                    return
                end

                --give dirtmoney
                local amount =  hpp.giveDirtMoney(current_robbery_id)
                animApi.stopAnim(false)
                TriggerEvent('cancelando', false)

                TriggerServerEvent(
                "hoppe:robbery:sendCopsNotification",
                "cancel", 
                "cancel", 
                "cancel",
                "<b>Sujeito roubou R$"..amount.." e está fugindo!</b>"
                )

                --notify("<b>~r~[AVISO] ~w~Você roubou ~g~R$"..amount.." ~w~sujos!</b>")
                TriggerEvent("Notify", "sucesso", "Você roubou R$"..amount.." sujos!")

                TriggerServerEvent("hoppe:robbery:delete:blip", current_robbery_coords)

                Citizen.Wait(120000)
                hpp.setRobberyStatus(false)
            end 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(near_robbery_idle)
        if roubando then
            drawTxt("FALTAM ~r~"..tostring(counter).."~w~ SEGUNDOS PARA FINALIZAR",4,0.5,0.91,0.36,255,255,255,200)
            drawTxt("APERTE ~g~CAPSLOCK~w~ PARA CANCELAR",4,0.5,0.88,0.36,255,255,255,200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(near_robbery_idle)
        if roubando then
            if IsControlJustPressed(0, 217) then
                cancel_action = true
                roubando = false
                counter = 0
                animApi.stopAnim(false)
                --notify("<b>~r~[AVISO] ~w~Você cancelou o assalto!</b>")
                TriggerEvent("Notify", "importante", "Você cancelou o assalto!")
                TriggerEvent('cancelando', false)
                TriggerServerEvent("hoppe:robbery:delete:blip", current_robbery_coords)
                TriggerServerEvent(
                "hoppe:robbery:sendCopsNotification",
                "cancel", 
                "cancel", 
                "cancel",
                "<b>[AVISO] Sujeito deixou o dinheiro para trás e saiu correndo!</b>"
                )

                Citizen.Wait(20 * 1000)
                hpp.setRobberyStatus(false)
            end
        end
    end
end)

local cop_blips = {  }

RegisterNetEvent("hoppe:robbery:sendCopsNotification")
AddEventHandler("hoppe:robbery:sendCopsNotification", function(x,y,z, _Msg)
    if hpp.checkPerm("policePerm") then
        if not exports.hpp_toogle.isToogle() then
            return
        end
        TriggerEvent("Notify", "importante", _Msg)

        if x ~= "cancel" then
            local cop_blip = AddBlipForCoord( x,y,z )
            table.insert(cop_blips, 1, { cop_blip, x,y,z })

            SetBlipSprite(cop_blip, 128)

            SetBlipRoute(cop_blip, true)
            SetBlipRouteColour(cop_blip, 1)

            SetBlipColour(cop_blip, 1)
            SetBlipScale(cop_blip, 0.7)
            SetBlipAsShortRange(cop_blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Roubo")
            EndTextCommandSetBlipName(cop_blip)

            Citizen.Wait(60 * 1000)

            RemoveBlip(cop_blip)
        end
    end
end)

RegisterNetEvent("hoppe:robbery:delete:blip")
AddEventHandler("hoppe:robbery:delete:blip", function(_CurrentCoords)
    print("[HPP_ROBBERY] => DELETE COP BLIP")
    local x,y,z = table.unpack(_CurrentCoords)
    for k,v in pairs(cop_blips) do
        if v[2] == x then
            RemoveBlip(V[1])
        end
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