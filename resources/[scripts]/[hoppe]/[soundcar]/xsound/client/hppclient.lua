xSound = exports.xsound

local musicId
local vehicle 
local vehicleMoldel
local playing = false
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    musicId = "music_id_" .. PlayerPedId()
    local pos
    while true do
        Citizen.Wait(100)
        if xSound:soundExists(musicId) and playing then
            if xSound:isPlaying(musicId) then
                pos = GetEntityCoords(vehicle)
                if vehicleModel == "PBUS2" then
                    TriggerServerEvent("myevent:soundStatus", "position", musicId, { vmodel = vehicleMoldel, position = pos })
                else
                    TriggerServerEvent("myevent:soundStatus", "position", musicId, { vmodel = vehicleMoldel, position = pos })
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

--[[RegisterCommand("playmusic", function(source, args, rawCommand)
    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        local pos = GetEntityCoords(vehicle)
        if not playing then
            TriggerServerEvent("myevent:soundStatus", "play", musicId, { position = pos, link = "https://www.youtube.com/watch?v=Ebu1s7kwO_s" })
            playing = true
        else
            TriggerEvent("Notify", "negado", "Já existe uma música tocando no momento!")
        end
    else
        TriggerEvent("Notify", "negado", "Você precisa estar dentro de um carro!")
    end
end, false)]]
RegisterNetEvent("hoppe:playmusic")
AddEventHandler("hoppe:playmusic", function(video_url)
    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        local _vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        if tonumber(GetVehicleClass(_vehicle)) == 8 then
            TriggerEvent("Notify", "negado", "Você não pode tocar música neste tipo de veículo!")
            return
        else
            if tonumber(GetVehicleClass(_vehicle)) == 13 then
                TriggerEvent("Notify", "negado", "Você não pode tocar música neste tipo de veículo!")
                return
            end
        end
        
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        vehicleMoldel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local vehicle_class = GetVehicleClass(vehicle)
        print(vehicle_class)
        local pos = GetEntityCoords(vehicle)
        if not playing then
            if tonumber(vehicle_class) ~= 8 then
                if tonumber(vehicle_class) ~= 13 then
                    TriggerServerEvent("myevent:soundStatus", "play", musicId, { vmodel = vehicleMoldel, position = pos, link = video_url })
                    playing = true
                else
                    TriggerEvent("Notify", "negado", "Você não pode colocar música neste tipo de veículo!")
                end
            else
                TriggerEvent("Notify", "negado", "Você não pode colocar música neste tipo de veículo!")
            end 
        else
            --TriggerEvent("Notify", "negado", "Já existe uma música tocando no momento!")
            if tonumber(vehicle_class) ~= 8 then
                if tonumber(vehicle_class) ~= 13 then
                    TriggerServerEvent("myevent:stopMusic", musicId)
                    Wait(1000)
                    TriggerServerEvent("myevent:soundStatus", "play", musicId, { vmodel = vehicleMoldel, position = pos, link = video_url })
                else
                    TriggerEvent("Notify", "negado", "Você não pode tocar música neste tipo de veículo!")
                end
            else
                TriggerEvent("Notify", "negado", "Você não pode tocar música neste tipo de veículo!")
            end
        end
    else
        TriggerEvent("Notify", "negado", "Você precisa estar dentro de um carro!")
    end
end, false)


--[[RegisterCommand("stopmusic", function(source, args, rawCommand)
    if playing then
        xSound:Destroy(musicId)
        playing = false
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)]]

RegisterNetEvent("hoppe:stopmusic")
AddEventHandler("hoppe:stopmusic", function()
    if playing then
        TriggerServerEvent("myevent:stopMusic", musicId)
        playing = false
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)

--[[RegisterCommand("pausemusic", function(source, args, rawCommand)
    if playing then
        xSound:Pause(musicId)
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)]]

RegisterNetEvent("hoppe:pausemusic")
AddEventHandler("hoppe:pausemusic", function()
    if playing then
        TriggerServerEvent("myevent:pauseMusic", musicId)
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)

--[[RegisterCommand("resumemusic", function(source, args, rawCommand)
    if playing then
        xSound:Resume(musicId)
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)]]

RegisterNetEvent("hoppe:resumemusic")
AddEventHandler("hoppe:resumemusic", function()
    if playing then
        TriggerServerEvent("myevent:resumeMusic", musicId)
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)

RegisterNetEvent("hoppe:changeVolum")
AddEventHandler("hoppe:changeVolum", function(volum)
    if playing then
        TriggerServerEvent("myevent:changeVolum", musicId, volum)
    else
        TriggerEvent("Notify", "negado", "Não há nenhuma música tocando agora!")
    end
end)

RegisterNetEvent("myevent:changeVolum")
AddEventHandler("myevent:changeVolum", function(musicId, volum)
    xSound:setVolume(musicId, tonumber(volum))
    print("[VOLUM]"..volum)
end)

RegisterNetEvent("myevent:soundStatus")
AddEventHandler("myevent:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            if not data.vmodel == "PBUS2" then
                xSound:Position(musicId, data.position)
                xSound:Distance(music_id, 20)
            end
            if (data.vmodel == "PBUS2") then
                xSound:Position(musicId, data.position)
                xSound:Distance(musicId, 200)
            end
        end
    end

    if type == "play" then
        xSound:PlayUrlPos(musicId, data.link, 1, data.position)
        if not data.vmodel == "PBUS2" then xSound:Distance(musicId, 20) end
        if data.vmodel == "PBUS2" then xSound:Distance(musicId, 200) end
    end
end)

RegisterNetEvent("myevent:stopMusic")
AddEventHandler("myevent:stopMusic", function(musicId)
    xSound:Destroy(musicId)
end)

RegisterNetEvent("myevent:pauseMusic")
AddEventHandler("myevent:pauseMusic", function(musicId)
    xSound:Pause(musicId)
end)

RegisterNetEvent("myevent:resumeMusic")
AddEventHandler("myevent:resumeMusic", function(musicId)
    xSound:Resume(musicId)
end)

