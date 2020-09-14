Citizen.CreateThread(function()
    local isDead = false

    while true do
        Citizen.Wait(0)

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local playerPed = PlayerPedId()

            if IsPedFatallyInjured(playerPed) and not isDead then
                isDead = true

                local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local killerServerId = NetworkGetPlayerIndexFromPed(killer)
        
                if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
                    PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
                else
                    PlayerKilled()
                end

            elseif not IsPedFatallyInjured(playerPed) then
                isDead = false
            end
        end
    end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
    local victimCoords = GetEntityCoords(PlayerPedId())
    local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
    local distance     = GetDistanceBetweenCoords(victimCoords, killerCoords, true)

    local data = {
     --   victimCoords = { x = tonumber(victimCoords.x, 1), y = tonumber(victimCoords.y, 1), z = tonumber(victimCoords.z, 1) },
     --   killerCoords = { x = tonumber(killerCoords.x, 1), y = tonumber(killerCoords.y, 1), z = tonumber(killerCoords.z, 1) },

        killedByPlayer = true,
        deathCause     = killerWeapon,
        distance       = tonumber(distance),

        killerServerId = killerServerId,
        killerClientId = killerClientId
    } 

    TriggerEvent('CKF:onPlayerDeath', data)
    TriggerServerEvent('CKF:onPlayerDeath', data)
end

function PlayerKilled()
    local playerPed = PlayerPedId()
    local victimCoords = GetEntityCoords(PlayerPedId())
    local data = {
  --      victimCoords = { x = tonumber(victimCoords.x, 1), y = tonumber(victimCoords.y, 1), z = tonumber(victimCoords.z, 1) },

        killedByPlayer = false,
        deathCause     = GetPedCauseOfDeath(playerPed)
    }
   -- TriggerServerEvent("fcxp:xpremovedeath")
    TriggerEvent('CKF:onPlayerDeath', data)
    TriggerServerEvent('CKF:onPlayerDeath', data)
end