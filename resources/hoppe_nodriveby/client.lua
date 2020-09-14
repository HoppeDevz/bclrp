local _nodrivebyVehList = {
    410882957 --kuruma2
}

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped)
        for k,v in pairs(_nodrivebyVehList) do
            if GetEntityModel(veh) == v then
                print(true)
                SetPlayerCanDoDriveBy(PlayerId(), false)
            else
                --print(false)
                SetPlayerCanDoDriveBy(PlayerId(), true)
            end
        end
        Citizen.Wait(2000)
    end
end)

RegisterCommand("hashveh", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    print(GetEntityModel(veh))
    notify("<b> ~r~[HASH DO VEÍCULO] ~w~"..GetEntityModel(veh).."</b>")
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