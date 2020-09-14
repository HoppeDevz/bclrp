local Tunnel = module("_core", "libs/Tunnel")
local Proxy = module("_core", "libs/Proxy")

cAPI = {}
Tunnel.bindInterface("cAPI", cAPI)
Proxy.addInterface("cAPI", cAPI)

API = Tunnel.getInterface("API")

cAPI.playerSpawned = false

AddEventHandler(
	"playerSpawned",
	function()
		TriggerServerEvent("pre_playerSpawned")
	end
)

AddEventHandler(
	"onResourceStart",
	function(resourceName)
		if (GetCurrentResourceName() ~= resourceName) then
			return
		end
		TriggerServerEvent("API:addReconnectPlayer")
	end
)

Citizen.CreateThread(
	function()
		SetMinimapHideFow(true)
	end
)

Citizen.CreateThread(function()
    while true do
		local playerPed = PlayerPedId()
		if playerPed and playerPed ~= -1 and cAPI.playerSpawned then
        	TriggerServerEvent('updatePosOnServerForPlayer', { table.unpack(GetEntityCoords(playerPed)) })
        end
        Citizen.Wait(TimeToSaveCharacter*1000)
    end
end)

local prompResult = nil
function cAPI.prompt(title, default_text)
	SendNUIMessage({act = "prompt", title = title, text = tostring(default_text)})
	SetNuiFocus(true)
	while prompResult == nil do
		Citizen.Wait(10)
	end
	local _temp = prompResult
	prompResult = nil
	return _temp
end

RegisterNUICallback(
	"prompt",
	function(data, cb)
		if data.act == "close" then
			SetNuiFocus(false)
			prompResult = data.result
		end
	end
)
local requests = {}

function cAPI.request(text, time)
	local id = math.random(999999)
	SendNUIMessage({act = "request", id = id, text = tostring(text), time = time})

	-- !!! OPTIMIZATION
	-- Stop the loop while the time has passed

	while requests[id] == nil do
		Citizen.Wait(10)
	end

	local _temp = requests[id] or false
	requests[id] = nil
	return _temp
end

RegisterNUICallback(
	"request",
	function(data, cb)
		if data.act == "response" then
			requests[data.id] = data.ok
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(3)
			if IsControlJustPressed(1, 166) then
				SendNUIMessage({act = "event", event = "yes"})
			end
			if IsControlJustPressed(1, 167) then
				SendNUIMessage({act = "event", event = "no"})
			end
		end
	end
)

function cAPI.clientConnected(bool)
	if bool then
		ShutdownLoadingScreenNui()
		ShutdownLoadingScreen()
	end
end
