local a=module('_core','libs/Proxy')local b=module('_core','libs/Tunnel')cAPI=a.getInterface('cAPI')API=b.getInterface('API')Inventory={}Inventory.Opened=false;Inventory.Delay=0;local c=false;Citizen.CreateThread(function()while true do c=cAPI.isHandcuffed()Citizen.Wait(500)end end)Citizen.CreateThread(function()while true do Citizen.Wait(0)if Inventory.Delay==0 then if IsControlJustReleased(1,243)and Inventory.isOpened()==false then TriggerServerEvent('_inventory:showInventory')end end;if Inventory.Opened then DisableControlAction(0,1,Inventory.Opened)DisableControlAction(0,2,Inventory.Opened)DisableControlAction(0,16,Inventory.Opened)DisableControlAction(0,17,Inventory.Opened)DisableControlAction(0,24,Inventory.Opened)DisableControlAction(0,257,Inventory.Opened)DisableControlAction(0,142,Inventory.Opened)DisableControlAction(0,106,Inventory.Opened)end end end)Citizen.CreateThread(function()while true do Citizen.Wait(1000)if Inventory.Delay>0 then Inventory.Delay=Inventory.Delay-1 end end end)RegisterNetEvent('_inventory:clientReceived')AddEventHandler('_inventory:clientReceived',function(d)Inventory.showInventory(d)end)RegisterNetEvent('_inventory:updateItems')AddEventHandler('_inventory:updateItems',function(d)Inventory.updateItems(d)end)function Inventory.showInventory(d)Inventory.Opened=true;SetNuiFocus(true,true)TriggerEvent("vrp_sound:source","zipper",0.04)SendNUIMessage({action="show_primary_inventory",items=d,language=cAPI.getUILanguage(GetCurrentResourceName())})end;function Inventory.updateItems(d)SendNUIMessage({action="UpdateItems",items=d})end;function Inventory.closeInventory()SetNuiFocus(false,false)Inventory.Opened=false;Inventory.Delay=1 end;function Inventory.isOpened()return Inventory.Opened end;RegisterNUICallback('_inventoryClose',function()Inventory.closeInventory()end)RegisterNUICallback('buttonsClicked',function(e)TriggerServerEvent('_inventory:funcItem',e)end)