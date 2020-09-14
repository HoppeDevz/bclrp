local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_call")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local calls = { 
    ["190"] = "pmesp",
    ["mec"] = "mecanico",
    ["192"] = "samu"
}

RegisterCommand("call", function(source, args, rawCommand)
    if args[1] then
        local x,y,z = table.unpack(GetEntityCoords( GetPlayerPed(-1) ))
        for k,v in pairs(calls) do
            if args[1] == k then
                if args[2] then
                    local msg = ""
                    for i = 2,#args do
                        msg = ""..msg.." "..args[i]..""
                    end
                    --print(msg)
                    TriggerServerEvent("hoppe:call:send", v, msg, x,y,z)

                    Citizen.Wait(20000)
                    local result = hpp.checkCall(x,y,z)
                    if result then
                        TriggerEvent("Notify", "sucesso", "Alguém aceitou seu chamado!")
                    else
                        TriggerEvent("Notify", "negado", "Ninguém aceitou seu chamado!")
                    end
                else
                    TriggerEvent("Notify", "negado", "Use: /call (n) (mensagem)")
                end
            end
        end
    end
end)

local callings = {}

Citizen.CreateThread(function() SetNuiFocus(false, false) end )

RegisterNetEvent("hoppe:call:send")
AddEventHandler("hoppe:call:send", function(_Perm, _Message, _x, _y, _z)
    local hasperm = hpp.hasGroup(_Perm)
    if hasperm then
        local x = ""
        for k,v in pairs(calls) do
            if v == _Perm then
                x = k
            end
        end

        TriggerEvent("Notify", "importante", "CHAMADO "..x..": ".._Message)
        table.insert(callings, #callings + 1, { _x, _y, _z, 20, _Message }) -- 30 => timeout
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        --print(callings[1])
        for l,w in pairs(callings) do
            if w[4] > 0 then
                callings[l][4] = callings[l][4] - 1
                --print("-1")
            else
                table.remove(callings, l)
                --print("remove")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 246) then
            if #callings > 0 then
                TriggerServerEvent("hoppe:call:acept", callings[1][1], callings[1][2], callings[1][3], callings[1][5])
            end
        end

        if IsControlJustPressed(0, 249) then
            TriggerEvent("Notify", "negado", "Você ignorou o chamado:"..callings[1][5].." ")
            table.remove(callings, 1)
        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SendNUIMessage({
            callings = callings
        })
    end
end)

RegisterNetEvent("hoppe:call:set:waypoint")
AddEventHandler("hoppe:call:set:waypoint", function(x,y,z, Message)
    TriggerEvent("Notify", "sucesso", "Você aceitou o chamado:"..Message.."!")
    --print("set way point", x, y)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent("hoppe:delete:ocorrence")
AddEventHandler("hoppe:delete:ocorrence", function(x,y,z)
    for p,j in pairs(callings) do
        if j[1] == x then
            table.remove(callings, p)
        end
    end
end)