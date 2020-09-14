needs = false
function cAPI.startNeeds()
    needs = true
    --TriggerEvent("fc_basicneeds:startUI") -- this is a start UI
end

function cAPI.isStartedNeeds()
    return needs
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            if IsPlayerPlaying(PlayerId()) and needs then
                local ped = PlayerPedId()
                local vthirst = 0
                local vhunger = 0

                if IsPedOnFoot(ped) then
                    local factor = math.min(cAPI.getSpeed(), 10)
                    vthirst = vthirst + 0.5 * factor
                    vhunger = vhunger + 0.5 * factor
                end

                if IsPedInMeleeCombat(ped) then
                    vthirst = vthirst + 6
                    vhunger = vhunger + 5
                end

                if IsPedInjured(ped) then
                    vthirst = vthirst + 2
                    vhunger = vhunger + 1
                end

                if vthirst ~= 0 then
                    API._varyThirst(GetPlayerServerId(PlayerId()), vthirst / 12.0)
                end

                if vhunger ~= 0 then
                    API._varyHunger(GetPlayerServerId(PlayerId()), vhunger / 12.0)
                end
            end
        end
    end
)

function cAPI.varyHealth(variation)
    local ped = PlayerPedId()
    local n = math.floor(GetEntityHealth(ped)+variation)
	SetEntityHealth(ped,n)
end