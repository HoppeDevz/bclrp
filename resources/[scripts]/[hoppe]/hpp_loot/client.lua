local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')local c=a.getInterface("hpp_loot")hppC={}a.bindInterface("hpp_loot",hppC)API=b.getInterface('API')cAPI=a.getInterface('cAPI')animApi=module("_core","client/functions/_Anims")local d=0;RegisterCommand("saquear",function(e,f,g)if GetEntityHealth(GetPlayerPed(-1))==101 or GetEntityHealth(GetPlayerPed(-1))<101 then return TriggerClientEvent("Notify","negado","Você está morto!")end;local d=getNearestPlayer(4)if d~=nil and d~=0 then TriggerServerEvent("hoppe:loot:openMenu",d)else return TriggerEvent("Notify","negado","Nenhum jogador perto!")end end)function getNearestPlayer(h)local i={}local j=GetPlayerPed(-1)local k,l,m=table.unpack(GetEntityCoords(j))for n,o in pairs(GetActivePlayers())do local p=GetPlayerServerId(o)local q=GetPlayerPed(o)local r,s,t=table.unpack(GetEntityCoords(q))local u=GetDistanceBetweenCoords(r,s,t,k,l,m,true)if u<h then i[p]=u end end;local e=0;local v=h+0.01;for w,x in pairs(i)do if x>0.0 then if x<v then v=x;e=w end end end;return e end;function ToogleLootHandler(y,z,A)SetNuiFocus(y,y)SendNUIMessage({open=y,items=z,selfitems=A})end;RegisterNUICallback("closeMenu",function()c.removeSourceInArray(d)ToogleLootHandler(false)end)RegisterNUICallback("giveItem",function(B)c.lootItem(B.itemname,B.quantity,d)end)RegisterNetEvent("hoppe:client:open:menu")AddEventHandler("hoppe:client:open:menu",function(C,z,A,D)d=parseInt(D)ToogleLootHandler(true,z,A)end)function hppC.isDead()return GetEntityHealth(GetPlayerPed(-1))==101 or GetEntityHealth(GetPlayerPed(-1))<101 end