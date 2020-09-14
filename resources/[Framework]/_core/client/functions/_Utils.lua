cAPI.Language = Language
cAPI.GameLanguage = GameLanguage

cAPI.UsingLanguageUI = UsingLanguageUI
cAPI.UILanguage = UILanguage

function cAPI.getGameLanguage()
	return cAPI.Language[cAPI.GameLanguage]
end	

function cAPI.getUILanguage(resourceName)
	return cAPI.UILanguage[cAPI.UsingLanguageUI][resourceName]
end	

function cAPI.getPosition()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	return x,y,z
end

function cAPI.teleport(x, y, z, spawn)
	SetEntityCoords(PlayerPedId(), x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
end

function cAPI.teleportSpawn(coordinate)
	local coords = json.decode(coordinate)
	cAPI.CameraWithSpawnEffect(coords)
	cAPI.playerSpawned = true
	--SetEntityCoords(PlayerPedId(), coords.x + 0.0001, coords.y + 0.0001, coords.z + 0.0001, 1, 0, 0, 1)
end

-- return vx,vy,vz
function cAPI.getSpeed()
	local vx, vy, vz = table.unpack(GetEntityVelocity(PlayerPedId()))
	return math.sqrt(vx * vx + vy * vy + vz * vz)
end

function cAPI.setModel(genero)    
	-- Citizen.CreateThread(function()
		RequestModel(genero)
        while not HasModelLoaded(genero) do
			Citizen.Wait(100)	
		end
        SetPlayerModel(PlayerId(), genero)
		SetPedDefaultComponentVariation(PlayerPedId(), true)
    -- end)
    return true    
end 

function cAPI.LoadModel(hash)
	local waiting = 0
	while not HasModelLoaded(hash) do
		waiting = waiting + 100
		Citizen.Wait(100)
		if waiting > 0 then
			break
		end
	end
	return true
end

function cAPI.removeClothes(hash)
end

function cAPI.setClothes(hash)
	local decoded = json.decode(hash)
	cAPI.SetClothing(decoded.drawables, decoded.drawTextures)
	return true
end

function cAPI.setSkin(hash)
	local decoded = json.decode(hash)
	cAPI.SetPedHeadBlend(decoded.headBlend)
	cAPI.SetHeadOverlayData(decoded.overlayHead)
	cAPI.SetHeadStructure(decoded.headStruct)
	cAPI.SetHairColor(decoded.getHair)
	cAPI.EndFade(500)
	return true
end

function cAPI.TargetT(Distance, Ped)
	local Entity = nil
	local camCoords = GetGameplayCamCoord()
	local farCoordsX, farCoordsY, farCoordsZ = cAPI.GetCoordsFromCam(Distance)
	local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, Ped, 0)
	local A,B,C,D,Entity = GetRaycastResult(RayHandle)
	return Entity, farCoordsX, farCoordsY, farCoordsZ
end

function cAPI.GetEntInFrontOfPlayer(Distance, Ped)
	local Ent = nil
	local CoA = GetEntityCoords(Ped, 1)
	local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
	local RayHandle = StartShapeTestRay(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, -1, Ped, 0)
	local A,B,C,D,Ent = GetRaycastResult(RayHandle)
	return Ent
end
  
-- Camera's coords
function cAPI.GetCoordsFromCam(distance)
	local rot = GetGameplayCamRot(2)
	local coord = GetGameplayCamCoord()

	local tZ = rot.z * 0.0174532924
	local tX = rot.x * 0.0174532924
	local num = math.abs(math.cos(tX))

	newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
	newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
	newCoordZ = coord.z + (math.sin(tX) * 8.0)
	return newCoordX, newCoordY, newCoordZ
end
  

function cAPI.getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
	local x = -math.sin(heading * math.pi / 180.0)
	local y = math.cos(heading * math.pi / 180.0)
	local z = math.sin(pitch * math.pi / 180.0)
	local len = math.sqrt(x * x + y * y + z * z)
	if len ~= 0 then
		x = x / len
		y = y / len
		z = z / len
	end
	return x, y, z
end

function cAPI.getNearestPlayer(radius)
	local r = {}
	local ped = GetPlayerPed(-1)
	local px, py, pz = table.unpack( GetEntityCoords(ped) )
	for k,v in pairs(GetActivePlayers()) do
		--print('k', k)
		--print('v', v)
		local playersrc = GetPlayerServerId(v)
		local oped = GetPlayerPed(v)
		local x,y,z = table.unpack(GetEntityCoords(oped))
		local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
		if distance < radius then
			r[playersrc] = distance
		end
	end

	local source = 0
	local min = radius + 0.01
	for l,w in pairs(r) do
		if w > 0.0 then
			if w < min then
				min = w
				source = l
			end
		end
	end

	return source
end

function cAPI.getWeapons()	
	local ped = PlayerPedId()
	local ammo_types = {}
	local weapons = {}
	for k, v in pairs(WeaponModels) do
		local hash = GetHashKey(v)
		if HasPedGotWeapon(ped, hash) then
			local atype = GetPedAmmoTypeFromWeapon(ped, hash)
			if ammo_types[atype] == nil then
				ammo_types[atype] = true
				weapons[v] = GetAmmoInPedWeapon(ped, hash)
			else
				weapons[v] = 0
			end
		end
	end

	return weapons
end

function cAPI.replaceWeapons(weapons)
	local old_weapon = cAPI.getWeapons()
	cAPI.giveWeapons(weapons, true)
	return old_weapon
end

function cAPI.giveWeapon(weapon, ammo, clear_before)
	cAPI.giveWeapons(
		{
			weapon = ammo
		},
		clear_before
	)
end

local handcuffed = false

function cAPI.toggleHandcuff()
	handcuffed = not handcuffed
	SetEnableHandcuffs(PlayerPedId(),handcuffed)
end

function cAPI.isHandcuffed()
	return handcuffed
end

function cAPI.getAllVehicles()
	local vehs = {}
	local it, veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
		EndFindVehicle(it)
	return vehs
end

function cAPI.getNearestVehicles(radius)
	local r = {}
	local px,py,pz = table.unpack( GetEntityCoords(GetPlayerPed(-1)) )
	for _,veh in pairs(cAPI.getAllVehicles()) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end

function cAPI.getNearestVehicle(radius)
	local veh
	local vehs = cAPI.getNearestVehicles(radius)
	local min = radius+0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh
end

function cAPI.giveWeapons(weapons, clear_before)
	Citizen.CreateThread(
		function()
			local ped = PlayerPedId()
			if clear_before then RemoveAllPedWeapons(ped, true, true) end
			for weapon, ammo in pairs(weapons) do
				local hash = GetHashKey(weapon)
				Citizen.InvokeNative(0xBF0FD6E56C964FCB, ped, hash, ammo or 0, false, false)
				Citizen.InvokeNative(0x5FD1E1F011E76D7E, ped, GetPedAmmoTypeFromWeapon(ped, hash), ammo )
			end
		end
	)
end

function cAPI.setArmour(amount)
	SetPedArmour(PlayerPedId(), amount)
end

function cAPI.getArmour()
	return GetPedArmour(PlayerPedId())
end

function cAPI.setHealth(amount)
	SetEntityHealth(PlayerPedId(), parseInt(amount) )
end

function cAPI.getHealth()
	return GetEntityHealth(PlayerPedId())
end


local noclip = false
local noclip_speed = 10.0

function cAPI.toggleNoclip()
	noclip = not noclip
	if noclip then
		SetEntityInvincible(PlayerPedId(), true)
		SetEntityVisible(PlayerPedId(), false, false)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
	else
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityVisible(PlayerPedId(), true, false)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if handcuffed then
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,20,true)
			DisableControlAction(0,21,true)
			DisableControlAction(0,23,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,271,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,177,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,246,true)
			DisableControlAction(0,303,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,344,true)
			DisableControlAction(0,245,true)
		end
	end
end)

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0)
			--SetEntityMaxHealth(PlayerPedId(), 150)
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
			if noclip then
				local ped = PlayerPedId()
				local x, y, z = cAPI.getPosition()
				local dx, dy, dz = cAPI.getCamDirection()
				local speed = noclip_speed
				SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

				if IsControlPressed(0, 32) then
					x = x + speed * dx
					y = y + speed * dy
					z = z + speed * dz
				end

				if IsControlPressed(0, 33) then
					x = x - speed * dx
					y = y - speed * dy
					z = z - speed * dz
				end

				if IsControlPressed(0, 21) then -- SHIFT
					noclip_speed = 10.0
				elseif IsControlPressed(0, 32) then -- CTRL
					noclip_speed = 0.2
				else
					noclip_speed = 1.0
				end

				SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
			end
		end
	end
)

function cAPI.teleportToWaypoint()
	if not IsWaypointActive() then
		return
	end
	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))
	local ground
	local groundFound = false
	local groundCheckHeights = {0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0}
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
	end
	for i, height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped, x, y, height, 0, 0, 1)

		RequestCollisionAtCoord(x, y, z)
		while not HasCollisionLoadedAroundEntity(ped) do
			RequestCollisionAtCoord(x, y, z)
			Citizen.Wait(1)
		end
		Citizen.Wait(20)

		ground, z = GetGroundZFor_3dCoord(x, y, height)
		if ground then
			z = z + 1.0
			groundFound = true
			break
		end
	end
	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0)
	end
	RequestCollisionAtCoord(x, y, z)
	while not HasCollisionLoadedAroundEntity(ped) do
		RequestCollisionAtCoord(x, y, z)
		Citizen.Wait(1)
	end
	SetEntityCoordsNoOffset(ped, x, y, z, 0, 0, 1)
end

function cAPI.playAnim(dict, anim, speed)
	if not IsEntityPlayingAnim(PlayerPedId(), dict, anim) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(100)
		end
		TaskPlayAnim(PlayerPedId(), dict, anim, speed, 1.0, -1, 0, 0, 0, 0, 0, 0, 0)
	end
end

function cAPI.createVehicle(modelName)
	local modelHash = GetHashKey(modelName)
	if not IsModelValid(modelHash) then
		return
	end
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(10)
		end
	end
	local ped = GetPlayerPed(-1)
	local nveh = CreateVehicle(modelHash, GetEntityCoords(ped), GetEntityHeading(ped), true, false, true)
	SetVehicleOnGroundProperly(nveh)
	SetEntityAsMissionEntity(nveh, true, true)
	TaskWarpPedIntoVehicle(ped, nveh, -1)
	SetModelAsNoLongerNeeded(modelHash)
	SetVehicleDirtLevel(nveh, 0)
end

function cAPI.isPlayingAnimation(dict, anim)
	local ped = PlayerPedId()
	return IsEntityPlayingAnim(ped, dict, anim, 3)
end

function cAPI.displayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function cAPI.DrawText(str, x, y, w, h, enableShadow, r, g, b, a, centre, font)
end

function cAPI.StartFade(timer)
    DoScreenFadeOut(timer)
    while IsScreenFadingOut() do
        Citizen.Wait(1)
    end
end

function cAPI.EndFade(timer)
    ShutdownLoadingScreen()
    DoScreenFadeIn(timer)
    while IsScreenFadingIn() do
        Citizen.Wait(1)
    end
end  