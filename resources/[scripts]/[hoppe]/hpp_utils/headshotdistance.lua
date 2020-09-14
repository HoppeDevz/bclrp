Citizen.CreateThread(function()
    while true do
        Wait(4)
        SetPedSuffersCriticalHits(PlayerPedId(-1), true)
    end
end)