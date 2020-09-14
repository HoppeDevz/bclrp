local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_bills")

hppC = {}
Tunnel.bindInterface("hpp_bills", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

function ToogleBillsMenu(_promise)
    SetNuiFocus(_promise, _promise)
    local _bills = hpp.getAllBills()
    SendNUIMessage({
        open = _promise,
        bills = _bills
    })
end

RegisterNUICallback("closeMenu", function()
    ToogleBillsMenu(false)
end)

RegisterNUICallback("generateBill", function(data)
    local id = data._id
    local payQtd = data._payQtd
    local desc = data._desc

    --print(id, payQtd, desc)
    hpp.createBill(id, payQtd, desc)
end)

RegisterNUICallback("payBill", function(data)
    local id = data.id
    local payQtd = data.payQtd
    local toId = data.toId

    local result = hpp.payBill(id, payQtd, toId)

    if result.error then
        --notify("<b>~r~[AVISO] ~w~Você não tem dinheiro para pagar este boleto!</b>")
        TriggerEvent("Notify", "negado", "Você não tem dinheiro para pagar este boleto!")
    else
        --notify("<b>~r~[AVISO] ~w~Você pagou um boleto de ~g~R$"..result.payQtd.."~w~ reais!</b>")
        TriggerEvent("Notify", "sucesso", "Você pagou um boleto de R$"..result.payQtd.." reais!")
    end
end)

RegisterCommand("mpago", function(source, args, rawCommand)
    ToogleBillsMenu(true)
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

RegisterNetEvent("bills-notify")
AddEventHandler("bills-notify", function(msg)
    notify(msg)
end)