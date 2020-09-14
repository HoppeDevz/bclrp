
RegisterCommand("towtruck", function()
	vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
	vehicletow = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))
end)

local reboque = nil
local rebocado = nil
RegisterCommand("tow",function(source,args)
	--local vehicle = GetPlayersLastVehicle()
	--local vehicletow = IsVehicleModel(vehicle,GetHashKey("flatbed"))

	if vehicletow and not IsPedInAnyVehicle(PlayerPedId()) then
		--rebocado = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
		rebocado = GetPlayersLastVehicle()
		if reboque == nil then
			if vehicle ~= rebocado then
				local min,max = GetModelDimensions(GetEntityModel(rebocado))
				AttachEntityToEntity(rebocado,vehicle,GetEntityBoneIndexByName(vehicle,"bodyshell"),0,-2.2,0.4-min.z,0,0,0,1,1,0,1,0,1)
				reboque = rebocado
			end
		else
			AttachEntityToEntity(reboque,vehicle,20,-0.5,-15.0,-0.3,0.0,0.0,0.0,false,false,true,false,20,true)
			DetachEntity(reboque,false,false)
			PlaceObjectOnGroundProperly(reboque)
			reboque = nil
			rebocado = nil
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if enablemechud then

			if vehicletow == nil then
				vehicletow = "NENHUM"
			end
			
			rebocado = GetDisplayNameFromVehicleModel(GetEntityModel(GetPlayersLastVehicle()))

			if rebocado == nil then
				rebocado = "NENHUM"
			elseif rebocado == "FLATBED" then
				rebocado = "NENHUM"	
			end	

			--print(vehicletow)
			--print(rebocado)

			if vehicletow ~= "FLATBED" then
				drawTxt("REBOQUE:~r~"..vehicletow,4,0.5,0.93,0.50,255,255,255,255)
			elseif vehicletow == "FLATBED" then
				drawTxt("REBOQUE:~g~"..vehicletow,4,0.5,0.93,0.50,255,255,255,255)
			end	
			drawTxt("REBOCADO:~r~"..rebocado,4,0.5,0.96,0.50,255,255,255,255)
		end
	end
end)

enablemechud = false
RegisterCommand("towhud", function()
	if not enablemechud then
		enablemechud = true
	elseif enablemechud then
		enablemechud = false
	end
end)