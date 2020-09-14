-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-bread" then
		TriggerServerEvent("comprar-mercearia","bread")
	elseif data == "comprar-water" then
		TriggerServerEvent("comprar-mercearia","water")
	elseif data == "comprar-energydrink" then
		TriggerServerEvent("comprar-mercearia","energydrink")
	elseif data == "comprar-backpack00" then
		TriggerServerEvent("comprar-mercearia","backpack00")
	elseif data == "comprar-backpack01" then
		TriggerServerEvent("comprar-mercearia","backpack01")
	elseif data == "comprar-radio" then
		TriggerServerEvent("comprar-mercearia","radio")
	elseif data == "comprar-clothes" then
		TriggerServerEvent("comprar-mercearia","clothes")
	elseif data == "comprar-phone" then
		TriggerServerEvent("comprar-mercearia","phone")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{25.65,-1346.58,29.49},
	{2556.75,382.01,108.62},
	{1163.54,-323.04,69.20},
	{-707.37,-913.68,19.21},
	{-47.73,-1757.25,29.42},
	{373.90,326.91,103.56},
	{-3243.10,1001.23,12.83},
	{1729.38,6415.54,35.03},
	{547.90,2670.36,42.15},
	{1960.75,3741.33,32.34},
	{2677.90,3280.88,55.24},
	{1698.45,4924.15,42.06},
	{-1820.93,793.18,138.11},
	{1392.46,3604.95,34.98},
	{-2967.82,390.93,15.04},
	{-3040.10,585.44,7.90},
	{1135.56,-982.20,46.41},
	{1165.91,2709.41,38.15},
	{-1487.18,-379.02,40.16},
	{-1222.78,-907.22,12.32}
}

local StoreIdle = 3000
local NearStore = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(StoreIdle)
		for _,mark in pairs(marcacoes) do
			if _ == 1 then NearStore = false end
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 10.0 then
				NearStore = true
				DrawMarker(27, x, y, z-0.97, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.1, 0, 255, 15, 30, 0, 0, 0, 1)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
					end
				end
			end
		end

		if NearStore then
			StoreIdle = 1
		else
			StoreIdle = 3000
		end
	end
end)

function newNotify(entry, color, elements, sound)
    if (color ~= -1) then
        SetNotificationBackgroundColor(color)
    end
    SetNotificationTextEntry(entry)
    for _, element in ipairs(elements) do
            AddTextComponentSubstringPlayerName(element)
    end
    DrawNotification(false, false)
    if (sound) then
        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
    end
end

function notify(msg)
	newNotify("STRING", 11, {"" .. msg}, true)
end

RegisterNetEvent("mercadinho-notify")
AddEventHandler("mercadinho-notify", function(message)
	notify(message)
	SetNuiFocus(true, true)
end)
