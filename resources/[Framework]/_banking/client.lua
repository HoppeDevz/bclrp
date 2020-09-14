local Proxy = module('_core', 'libs/Proxy')
local Tunnel = module('_core', 'libs/Tunnel')

cAPI = Proxy.getInterface('cAPI')
API = Tunnel.getInterface('API')

local objects = {
    "prop_fleeca_atm",
    "prop_atm_01","prop_atm_02",
    "prop_atm_03"
}
Bank = {}
Bank.ATM = nil
Bank.Delay = 0

---------------------------------------------
--THREADS------------------------------------
---------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        position = GetEntityCoords(PlayerPedId())
        for k,v in pairs(objects) do
            Bank.ATM = GetClosestObjectOfType(position.x,position.y,position.z, 1.0, GetHashKey(v), true)
            if Bank.ATM ~= 0 then
                break;
            end
        end
    end
end)    

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Bank.ATM ~= 0 then
            if Bank.Delay == 0 then
                if IsControlJustReleased(1,  38)  then
                    Bank.Open()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if Bank.Delay > 0 then
            Bank.Delay = Bank.Delay - 1
        end
    end
end)

---------------------------------------------
--FUNCTIONS----------------------------------
---------------------------------------------
function Bank.Open()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show_bank"
    })     
    Bank.Opened = true
end

function Bank.closeBank()
    Bank.Delay = 1
    SetNuiFocus(false, false)
    Bank.Opened = false
end

function Bank.isOpened()
    return Bank.Opened 
end

-------------------------------------------------
--REGISTER NUI CALLBACKS-------------------------
-------------------------------------------------
RegisterNUICallback('_bankClose', function()
    Bank.closeBank()
end)

AddEventHandler('onResourceStart', function(resName)
    if GetCurrentResourceName() == resName then
        Bank.closeBank()
    end
end)