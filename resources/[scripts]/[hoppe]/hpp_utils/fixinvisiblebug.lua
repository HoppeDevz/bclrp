Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        NetworkSetEntityInvisibleToNetwork( GetPlayerPed(-1), false )
    end
end)