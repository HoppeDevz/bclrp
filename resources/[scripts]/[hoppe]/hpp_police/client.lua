local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')API=b.getInterface('API')cAPI=a.getInterface('cAPI')hppServerPolice=a.getInterface("hpp_police")hpp_police_client={}a.bindInterface("hpp_police",hpp_police_client)animApi=module("_core","client/functions/_Anims")Citizen.CreateThread(function()while true do Citizen.Wait(5*60*1000)collectgarbage("count")collectgarbage("collect")end end)local c=0;RegisterNetEvent("hoppe:prender")AddEventHandler("hoppe:prender",function(d)local ped=GetPlayerPed(-1)SetEntityCoords(ped,1682.2010498047,2507.634765625,45.564727783203)TriggerEvent("Notify","importante","Você foi preso por "..tostring(d).." anos!")c=parseInt(d)end)RegisterCommand("prender",function(e,f,g)if hppServerPolice.checkPerm("policePerm")then if f[2]then TriggerServerEvent("hoppe:server:prender",parseInt(f[1]),parseInt(f[2]))end else TriggerEvent("Notify","negado","Você não é um policial!")end end)RegisterNetEvent("hoppe:build:prison:time")AddEventHandler("hoppe:build:prison:time",function(h)if h then c=parseInt(h)print("prison time updated!"..h)end end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if c then if c>0 then TriggerEvent("Notify","importante","Restam "..c.." ano(s) para você sair!")c=c-1;TriggerServerEvent("hoppe:setPrisonTime",c)Citizen.Wait(60*1000)TriggerServerEvent("hoppe:build:prison:time")Citizen.Wait(2000)if c==0 then SetEntityCoords(GetPlayerPed(-1),1831.6907958984,2608.2563476563,45.588275909424)TriggerEvent("Notify","sucesso","Liberdade cantou!")end end end end end)other=nil;drag=false;carregado=false;RegisterNetEvent("carregar")AddEventHandler("carregar",function(i)other=i;drag=not drag end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if drag and other then local ped=GetPlayerPed(GetPlayerFromServerId(other))Citizen.InvokeNative(0x6B9BBD38AB0796DF,PlayerPedId(),ped,4103,11816,0.48,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)carregado=true else if carregado then DetachEntity(PlayerPedId(),true,false)carregado=false end end end end)function hpp_police_client.gethealth()return GetEntityHealth(GetPlayerPed(-1))end;Citizen.CreateThread(function()while true do Citizen.Wait(1)local ped=GetPlayerPed(-1)if IsControlJustPressed(0,47)then local j=getNearestPlayer(4)if exports.hpp_toogle.isToogle()then TriggerServerEvent("hoppe:algema",j)end end end end)local k=false;local l={{['x']=348.32,['y']=-576.42,['z']=43.28,['x2']=349.66,['y2']=-575.79,['z2']=43.20,['h']=335.16},{['x']=350.32,['y']=-576.42,['z']=43.28,['x2']=351.67,['y2']=-576.79,['z2']=43.20,['h']=335.16},{['x']=353.17,['y']=-578.17,['z']=43.28,['x2']=354.17,['y2']=-577.81,['z2']=43.20,['h']=335.16},{['x']=355.62,['y']=-578.75,['z']=43.28,['x2']=356.66,['y2']=-578.47,['z2']=43.20,['h']=335.16},{['x']=357.87,['y']=-579.55,['z']=43.28,['x2']=359.01,['y2']=-579.28,['z2']=43.20,['h']=335.16},{['x']=350.22,['y']=-581.86,['z']=43.28,['x2']=349.03,['y2']=-582.32,['z2']=43.20,['h']=157.19},{['x']=352.75,['y']=-582.65,['z']=43.28,['x2']=351.65,['y2']=-583.20,['z2']=43.20,['h']=157.19},{['x']=355.31,['y']=-583.85,['z']=43.28,['x2']=354.24,['y2']=-584.33,['z2']=43.20,['h']=157.19},{['x']=357.78,['y']=-584.59,['z']=43.28,['x2']=356.74,['y2']=-585.04,['z2']=43.20,['h']=157.19}}local m=3000;Citizen.CreateThread(function()while true do Citizen.Wait(m)for n,o in pairs(l)do local ped=PlayerPedId()local p,q,r=table.unpack(GetEntityCoords(ped))local s,t=GetGroundZFor_3dCoord(o.x,o.y,o.z)local u=GetDistanceBetweenCoords(o.x,o.y,t,p,q,r,true)if u<10 then m=1 else m=3000 end;if u<=1.5 then drawTxt("~b~E~w~  DEITAR    ~b~G~w~  TRATAMENTO",4,0.5,0.93,0.50,255,255,255,180)if IsControlJustPressed(0,38)then SetEntityCoords(ped,o.x2,o.y2,o.z2)SetEntityHeading(ped,o.h)k=true;animApi.playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)end end end end end)RegisterCommand("tratamento",function(e,f,g)local j=getNearestPlayer(4)TriggerServerEvent("tratamento-macas",j)end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if k then if IsControlJustPressed(0,167)then k=false end end end end)function hpp_police_client.returnlying()return k end;RegisterNetEvent("tratamento-macas")AddEventHandler("tratamento-macas",function()local ped=GetPlayerPed(-1)local v=GetEntityHealth(ped)while v<GetPedMaxHealth(ped)do Citizen.Wait(1000)v=v+1;print("health",v)SetEntityHealth(ped,GetEntityHealth(ped)+1)end end)RegisterNetEvent("hoppe:medhealing")AddEventHandler("hoppe:medhealing",function(w)if w=="healing"then local ped=GetPlayerPed(-1)local v=GetEntityHealth(ped)if v==101 then Citizen.Wait(15000)SetEntityHealth(ped,117)end elseif w=="anim"then TriggerEvent("cancelando",true)animApi.playAnim(false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)Citizen.Wait(15000)animApi.stopAnim(false)TriggerEvent("cancelando",false)end end)function getNearestPlayer(x)local y={}local ped=GetPlayerPed(-1)local z,A,B=table.unpack(GetEntityCoords(ped))for n,o in pairs(GetActivePlayers())do local C=GetPlayerServerId(o)local D=GetPlayerPed(o)local p,q,r=table.unpack(GetEntityCoords(D))local u=GetDistanceBetweenCoords(p,q,r,z,A,B,true)if u<x then y[C]=u end end;local e=0;local E=x+0.01;for F,G in pairs(y)do if G>0.0 then if G<E then E=G;e=F end end end;return e end;function getNearestPlayerPed(x)local y={}local ped=GetPlayerPed(-1)local z,A,B=table.unpack(GetEntityCoords(ped))for n,o in pairs(GetActivePlayers())do local C=GetPlayerServerId(o)local D=GetPlayerPed(o)local p,q,r=table.unpack(GetEntityCoords(D))local u=GetDistanceBetweenCoords(p,q,r,z,A,B,true)if u<x then y[D]=u end end;local e=0;local E=x+0.01;for F,G in pairs(y)do if G>0.0 then if G<E then E=G;e=F end end end;return e end;function getAllVehicles()local H={}local I,J=FindFirstVehicle()if J then table.insert(H,J)end;local K;repeat K,J=FindNextVehicle(I)if K and J then table.insert(H,J)end until not K;EndFindVehicle(I)return H end;function getNearestVehicles(x)local y={}local z,A,B=table.unpack(GetEntityCoords(GetPlayerPed(-1)))for L,J in pairs(getAllVehicles())do local p,q,r=table.unpack(GetEntityCoords(J))local u=GetDistanceBetweenCoords(p,q,r,z,A,B,true)if u<=x then y[J]=u end end;return y end;RegisterNetEvent("hpp:put:in:vehicle")AddEventHandler("hpp:put:in:vehicle",function()local J=getNearestVehicle(4)local M=getNearestPlayer(2)if M then if IsEntityAVehicle(J)then for N=1,math.max(GetVehicleMaxNumberOfPassengers(J),3)do if IsVehicleSeatFree(J,N)then SetPedIntoVehicle(GetPlayerPed(-1),J,N)return true end end end else return false end end)RegisterNetEvent("hpp:eject:vehicle")AddEventHandler("hpp:eject:vehicle",function()local ped=PlayerPedId()if IsPedSittingInAnyVehicle(ped)then local J=GetVehiclePedIsIn(ped,false)TaskLeaveVehicle(ped,J,4160)end end)function getCarroClass(vehicle)return GetVehicleClass(vehicle)==0 or GetVehicleClass(vehicle)==1 or GetVehicleClass(vehicle)==2 or GetVehicleClass(vehicle)==3 or GetVehicleClass(vehicle)==4 or GetVehicleClass(vehicle)==5 or GetVehicleClass(vehicle)==6 or GetVehicleClass(vehicle)==7 or GetVehicleClass(vehicle)==9 or GetVehicleClass(vehicle)==12 end;local O=false;function toggleMalas()O=not O;ped=PlayerPedId()vehicle=getNearestVehicle(7)if IsEntityAVehicle(vehicle)then if O then AttachEntityToEntity(ped,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-0.4,-0.1,60.0,-90.0,180.0,false,false,false,true,2,true)SetEntityVisible(ped,false)SetEntityInvincible(ped,true)else DetachEntity(ped,true,true)SetEntityVisible(ped,true)SetEntityInvincible(ped,false)SetPedToRagdoll(ped,2000,2000,0,0,0,0)end;TriggerServerEvent("trymala",VehToNet(vehicle))end end;RegisterNetEvent("syncmala")AddEventHandler("syncmala",function(P)if NetworkDoesNetworkIdExist(P)then local o=NetToVeh(P)if DoesEntityExist(o)then if IsEntityAVehicle(o)then SetVehicleDoorOpen(o,5,0,0)Citizen.Wait(1000)SetVehicleDoorShut(o,5,0)end end end end)RegisterNetEvent("hpp:sequestro")AddEventHandler("hpp:sequestro",function()local Q=cAPI.isHandcuffed()if not IsPedInAnyVehicle(PlayerPedId())then local vehicle=getNearestVehicle(7)if vehicle~=0 and vehicle~=nil then if getCarroClass(vehicle)then toggleMalas()end end elseif O then toggleMalas()end end)RegisterCommand("sequestro",function()local j=getNearestPlayer(4)if j~=0 then TriggerServerEvent("hpp:sequestro",j)end end)RegisterCommand("cv",function(e,f,g)local j=getNearestPlayer(4)if j~=0 then TriggerServerEvent("hpp:put:in:vehicle",j)end end)RegisterCommand("rv",function(e,f,g)local j=getNearestPlayer(4)if j~=0 then TriggerServerEvent("hpp:eject:vehicle",j)end end)function getNearestVehicle(x)local J;local H=getNearestVehicles(x)local E=x+0.0001;for R,S in pairs(H)do if S<E then E=S;J=R end end;return J end;RegisterCommand("id",function(e,f,g)local j=getNearestPlayer(8)TriggerServerEvent("hoppe:show:id",j)end)RegisterCommand("re",function(e,f,g)local T=hppServerPolice.checkPerm("medicPerm")if T then local j=getNearestPlayer(4)TriggerServerEvent("hoppe:medhealing",j)else TriggerEvent("Notify","negado","Você não tem permissão!")end end)RegisterNetEvent("hoppe:pd:chat:event")AddEventHandler("hoppe:pd:chat:event",function(U,V,W)TriggerServerEvent("hoppe:pd:chat:event",U,V,W)end)function newNotify(X,Y,Z,_)if Y~=-1 then SetNotificationBackgroundColor(Y)end;SetNotificationTextEntry(X)for L,a0 in ipairs(Z)do AddTextComponentSubstringPlayerName(a0)end;DrawNotification(false,false)if _ then PlaySoundFrontend(-1,"Menu_Accept","Phone_SoundSet_Default",1)end end;RegisterCommand("prisontime",function(e,f,g)print("hppServerPolice.getPrisonTime()",hppServerPolice.getPrisonTime())end)function notify(a1)newNotify("STRING",11,{""..a1},true)end;RegisterNetEvent("med-notify")AddEventHandler("med-notify",function(a1)notify(a1)end)function hpp_police_client.playAnim(i,a2,a3,a4)animApi.playAnim(i,{{a2,a3}},a4)end;function hpp_police_client.stopAnim(i)animApi.stopAnim(i)end;Citizen.CreateThread(function()while true do Citizen.Wait(1)local ped=GetPlayerPed(-1)if IsControlJustPressed(0,74)then local j=getNearestPlayer(4)if exports.hpp_toogle.isToogle()then TriggerServerEvent("hoppe:carregar",j)end end end end)local a5=false;local a6=0;RegisterNetEvent("hoppe:set:wanted:level")AddEventHandler("hoppe:set:wanted:level",function(W,d)if not a5 then local p,q,r=table.unpack(GetEntityCoords(GetPlayerPed(-1)))TriggerServerEvent("hoppe:wanted:sendNotify",p,q,r,W,true,d,GetPlayerPed(-1))a5=true;a6=parseInt(d)end end)RegisterCommand("garmas",function(e,f,g)local a7=hppServerPolice.checkPerm("policePerm")if a7 then return RemoveAllPedWeapons(GetPlayerPed(-1),true)else local a8=getWeapons()hppServerPolice.stockWeapons(a8)end end)RegisterNetEvent("hpp:stock:weapons")AddEventHandler("hpp:stock:weapons",function()RemoveAllPedWeapons(GetPlayerPed(-1),true)end)local a9=module("hpp_police","weapon_types")function getWeapons()local aa=PlayerPedId()local ab={}local a8={}for n,o in pairs(a9)do local ac=GetHashKey(o)if HasPedGotWeapon(aa,ac)then local ad={}a8[o]=ad;local ae=Citizen.InvokeNative(0x7FEAD38B326B9F74,aa,ac)if ab[ae]==nil then ab[ae]=true;ad.ammo=GetAmmoInPedWeapon(aa,ac)else ad.ammo=0 end end end;return a8 end;local af={}RegisterNetEvent("hoppe:wanted:sendNotify")AddEventHandler("hoppe:wanted:sendNotify",function(p,q,r,W,ag,ah,ai)if hppServerPolice.checkPerm("policePerm")then local wantedblip=AddBlipForCoord(p,q,r)table.insert(af,1,{wantedblip,tonumber(ah),ai})SetBlipSprite(wantedblip,161)SetBlipRoute(wantedblip,false)SetBlipColour(wantedblip,1)SetBlipScale(wantedblip,1.1)SetBlipAsShortRange(wantedblip,false)BeginTextCommandSetBlipName("STRING")AddTextComponentString("Roubo")EndTextCommandSetBlipName(wantedblip)TriggerEvent("Notify","importante",W)end end)Citizen.CreateThread(function()while true do Citizen.Wait(1000)if#af>0 then for n,o in pairs(af)do if o[2]>0 then o[2]=o[2]-1 else RemoveBlip(o[1])table.remove(af,n)end end end end end)RegisterNetEvent("hoppe:jacking:updateBlipPos")AddEventHandler("hoppe:jacking:updateBlipPos",function(p,q,r,ai)if hppServerPolice.checkPerm("policePerm")then if#af>0 then for n,o in pairs(af)do if o[3]==ai then SetBlipCoords(o[1],p,q,r)end end end end end)RegisterNetEvent("hoppe:wanted:removeBlip")AddEventHandler("hoppe:wanted:removeBlip",function()if hppServerPolice.checkPerm("policePerm")then if wantedblip then RemoveBlip(wantedblip)wantedblip=nil end end end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if a5 then a6=a6-1;local p,q,r=table.unpack(GetEntityCoords(GetPlayerPed(-1)))TriggerServerEvent("hoppe:jacking:updateBlipPos",p,q,r,GetPlayerPed(-1))Citizen.Wait(1000)if a6==0 then a5=false;TriggerEvent("Notify","importante","Você parou de ser rastreado pelos políciais!")end end end end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if a5 then drawTxt("VOCÊ ESTÁ SENDO ~r~PROCURADO",4,0.92,0.76,0.36,255,255,255,240)drawTxt("TEMPO RESTANTE: ~y~"..a6 .."S",4,0.92,0.78,0.36,255,255,255,240)end end end)function drawTxt(aj,ak,p,q,al,y,am,an,ao)SetTextFont(ak)SetTextScale(al,al)SetTextColour(y,am,an,ao)SetTextOutline()SetTextCentre(1)SetTextEntry("STRING")AddTextComponentString(aj)DrawText(p,q)end;function drawTxt(aj,ak,p,q,al,y,am,an,ao)SetTextFont(ak)SetTextScale(al,al)SetTextColour(y,am,an,ao)SetTextOutline()SetTextCentre(1)SetTextEntry("STRING")AddTextComponentString(aj)DrawText(p,q)end