Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        NetworkSetFriendlyFireOption(true)  
        SetCanAttackFriendly(PlayerPedId(), true, true)
    end
end)