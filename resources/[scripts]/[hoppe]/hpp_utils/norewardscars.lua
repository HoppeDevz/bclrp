Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)