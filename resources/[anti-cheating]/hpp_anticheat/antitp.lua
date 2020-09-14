local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_anticheat")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x1,y1,z1 = table.unpack( GetEntityCoords(ped) )
        Citizen.Wait(900)
        local x2,y2,z2 = table.unpack( GetEntityCoords(ped) )
        local distance = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true)

        local charid = hpp.getCharId()

        --print(distance)
        if distance > 100 then
            local title = "**😈 SUSPEITO DE CHEATING 😈**"
            local fields = {
                {
                    name = "ID:",
                    value = "`"..hpp.getCharId().."`"
                },
                {
                    name = "Cheating:",
                    value = "`Teleporte`"
                }
            }
            if hpp.isAdmin() then
                return
            end
            TriggerServerEvent("SendDiscordWebhook", "AntiCheatLog", title, fields)
        end
    end
end)

local first_report_accuracy = false
Citizen.CreateThread(function()
    while true do
        local GetPedAccuracy = GetPedAccuracy(GetPlayerPed(-1))
        --print('GetPedAccuracy', GetPedAccuracy)
        if GetPedAccuracy < 100 then

            local charid = hpp.getCharId()

            if not first_report_accuracy then
                first_report_accuracy = true

                local title = "**😈 SUSPEITO DE CHEATING 😈**"
                local fields = {
                    {
                        name = "ID:",
                        value = "`"..hpp.getCharId().."`"
                    },
                    {
                        name = "Cheating:",
                        value = "`Recoil Hack`"
                    },
                    {
                        name = "Default:",
                        value = "`100`"
                    },
                    {
                        name = "PlayerModify:",
                        value = "`"..tostring(GetPedAccuracy).."`"
                    }
                }
                if hpp.isAdmin() then
                    return
                end
                TriggerServerEvent("SendDiscordWebhook", "AntiCheatLog", title, fields)
            end
        end
        Citizen.Wait(1)
    end
end)

local first_report_armour = false
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local armour = GetPedArmour(ped)
        --print( 'armour', armour )
        if armour > 0 then
            if not first_report_armour then
                first_report_armour = true
                local title = "**😈 SUSPEITO DE CHEATING 😈**"
                local fields = {
                    {
                        name = "ID:",
                        value = "`"..hpp.getCharId().."`"
                    },
                    {
                        name = "Cheating:",
                        value = "`Kevlar`"
                    },
                    {
                        name = "Default:",
                        value = "`0`"
                    },
                    {
                        name = "PlayerModify:",
                        value = "`"..tostring(armour).."`"
                    }
                }
                if hpp.isAdmin() then
                    return
                end
                TriggerServerEvent("SendDiscordWebhook", "AntiCheatLog", title, fields)
            end
        end 
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)

        Citizen.Wait(200)
        local health2 = GetEntityHealth(ped)
        if health2 - health > 2 then
            local title = "**😈 SUSPEITO DE CHEATING 😈**"
            local fields = {
                {
                    name = "ID:",
                    value = "`"..hpp.getCharId().."`"
                },
                {
                    name = "Cheating:",
                    value = "`Health`"
                },
                {
                    name = "De:",
                    value = "`"..tostring(health).."`"
                },
                {
                    name = "Para:",
                    value = "`"..tostring(health2).."`"
                },
                {
                    name = "Em:",
                    value = "`200ms`"
                }
            }
            if hpp.isAdmin() then
                return
            end
            TriggerServerEvent("SendDiscordWebhook", "AntiCheatLog", title, fields)
        end

        Citizen.Wait(1)
    end
end)