local vels = {
    58.0,
    58.2,
    58.3,
    58.4,
    58.5
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped)
        if veh ~= nil and veh ~= nil then
            if IsPedSittingInAnyVehicle(ped) then
                local random_number = math.random(1, 5)
                --print("random_number", random_number)
                SetVehicleMaxSpeed(veh, vels[random_number])
            end
        end
    end
end)