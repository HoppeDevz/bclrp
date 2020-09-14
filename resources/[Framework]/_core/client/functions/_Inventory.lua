Pickups = {}
Verify = {}
function cAPI.createPickup(id, amount, name)
    Citizen.CreateThread(function()
        local ped     = PlayerPedId()
        local coords  = GetEntityCoords(ped)
        local forward = GetEntityForwardVector(ped)
        local x, y, z = table.unpack(coords + forward * 1.6)
        if cAPI.LoadModel(GetHashKey("hei_prop_heist_binbag")) then
            local obj = CreateObject(GetHashKey("hei_prop_heist_binbag"), x, y, z, true, false, true)
            PlaceObjectOnGroundProperly(obj)
            SetEntityAsMissionEntity(obj, true, false)
            FreezeEntityPosition(obj , true)
            API._pickupServer(id, amount, name, obj , x, y, z)
            PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
        end
    end)
    return true
end

function cAPI.sharedPickup(id, amount, name, obj , range, x, y, z)
    Citizen.CreateThread(function()
        if range == 1 then
            Pickups[obj] = {
                id = id,
                amount = amount,
                name = name,
                obj = obj,
                inRange = false,
                coords = {x = x, y = y, z = z}
            }
        else
            Pickups[obj] = nil
        end
    end)
end

function cAPI.removeObject(obj)
    SetEntityAsMissionEntity(obj, false, true)
    NetworkRequestControlOfEntity(obj)
    local timeout = 0
    while not NetworkHasControlOfEntity(obj) and timeout < 5000 do
        timeout = timeout+100
        if timeout == 5000 then
            print('Never got control of' .. obj)
        end
        Wait(100)
    end
    DeleteEntity(obj)
    FreezeEntityPosition(obj , false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        if next(Pickups) == nil then
            Citizen.Wait(500)
        end
        for k,v in pairs(Pickups) do
            local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
            if distance >= 15.0 then
                wait = 2000
            else
                wait = 200
            end
            if distance <= 2.0 and not v.inRange then
                v.inRange = true
                if v.obj then
                    if Verify[v.obj] == nil then
                        Verify[v.obj] = {
                            obj = v.obj,
                            range = v.inRange,
                            amount = v.amount,
                            name = v.name
                        }
                    end
                end
            elseif distance >= 2.0 and v.inRange then
                v.inRange = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Verify) do
            if Verify[k] ~= nil and Pickups[Verify[k].obj].inRange then
                cAPI.displayHelpText("Pressione ~INPUT_PICKUP~ para pegar "..Verify[k].amount.."x "..Verify[k].name)
                if IsControlJustPressed(1, 38)  then
                    TaskLookAtEntity(playerPed, Verify[k].obj , 3000 ,2048 , 3)
                    PlaySoundFrontend("PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true, 1)
                    local result = API._pickOn(Verify[k].obj)
                    if not result then
                        --notify("<b> ~r~[AVISO] ~w~Espaço insuficiente!</b>")
                        --TriggerEvent("Notify", "negado", "Espaço insuficiente!")
                    end
                    Verify[k] = nil
                end
            end
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
