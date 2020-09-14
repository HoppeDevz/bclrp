-------------------------- Desativa atirar dentro do carro exceto o heli da polícia-------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
---------- BLOQUEIA QUALQUER ARMA DE ATIRAR ------------------------------------
            SetPlayerCanDoDriveBy(PlayerId(),false)
            
            local vehicle = GetVehiclePedIsIn(ped)
            local speed = GetEntitySpeed(vehicle)*3.6

---------------- CONDIÇÃO P2 ---------------------------
            if GetPedInVehicleSeat(vehicle,0) == ped then
                if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            elseif GetPedInVehicleSeat(vehicle,-1) == ped then
                if speed <= 70 then
                    if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                        SetPlayerCanDoDriveBy(PlayerId(),true)
                    end
                end
            else
                if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("policiaheli")) then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            end
        end
    end
end)