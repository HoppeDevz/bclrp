local armas = {
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_REVOLVER",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_COMBATPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_MACHINEPISTOL"
}

animApi = module("_core", "client/functions/_Anims")

local holstering_gun = false 
 
 Citizen.CreateThread(function()
    while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
				loadAnimDict( "reaction@intimidation@1h" )
				if CheckWeapon(ped) then
						if holstered then
							holstering_gun = true
							animApi.playAnim(true,{{"reaction@intimidation@1h", "intro"}},false)
							Citizen.Wait(1700)
							ClearPedTasks(ped)
							holstered = false
							holstering_gun = false
						end
						SetPedComponentVariation(ped, 0, 0, 0, 0)
				else
						if not holstered then
								TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 1.0, -1, 48, 0, 0, 0, 0 )
								Citizen.Wait(1500)
								ClearPedTasks(ped)
								holstered = true
						end
						SetPedComponentVariation(ped, 0, 0, 0, 0)
				end
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if holstering_gun then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		end
	end
end)


function CheckWeapon(ped)
	for i = 1, #armas do
		if GetHashKey(armas[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end