local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_cet")

hppC = {}
Tunnel.bindInterface("hpp_cet", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local cfg = module("hpp_cet", "config/cfg")

animApi = module("_core", "client/functions/_Anims")

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x1,y1,z1 = table.unpack( GetEntityCoords(ped) )
        local x2,y2,z2 = cfg.delspot[1], cfg.delspot[2], cfg.delspot[3]

        local distance = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true)

        if distance < 20 then
            DrawMarker(23,x2,y2,z2 - 0.989,0,0,0,0,0,0,5.5,5.5,5.5,0,150,150,50,0,0,0,0)
            if distance < 5.5 then
                drawTxt("PRESSIONE ~b~E~w~ PARA DESMANCHAR O CARRO!",4,0.50,0.90,0.56,255,255,255,240)
                if IsControlJustPressed(0, 38) then
                    BreakCarHandle()
                end
            end
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    local workblip = AddBlipForCoord(cfg.blipcoords[1], cfg.blipcoords[2], cfg.blipcoords[3])
    SetBlipSprite(workblip,60)
    SetBlipAsShortRange(workblip,true)
    SetBlipColour(workblip,4)
    SetBlipScale(workblip,0.4)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Central | CET")
    EndTextCommandSetBlipName(workblip)
end)

function BreakCarHandle() 
    local ped = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(ped) then
        --return notify("<b>~r~[AVISO] ~w~Você deve estar dentro do carro!</b>")
        return TriggerEvent("Notify", "negado", "Você deve estar dentro do carro!")
    end

    local veh = GetVehiclePedIsIn(ped)
    local plate = GetVehicleNumberPlateText(veh)
    if string.find(plate, "RP") ~= nil then
        --return notify("<b>~r~[AVISO] ~w~Você não pode desmanchar este carro!</b>")
        return TriggerEvent("Notify", "negado", "Você não pode desmanchar este carro!")
    end

    TaskLeaveVehicle(ped, veh, 64)
    DelVehicle(veh)
end

function DelVehicle(_HashVeh)
    Citizen.Wait(1800)
    DeleteEntity(_HashVeh)
    local reward = hpp.givereward()
    --notify("<b>~r~[AVISO] ~w~Você ganhou ~g~R$"..reward.."</b>")
    TriggerEvent("Notify", "sucesso", "Você ganhou R$"..reward)
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
