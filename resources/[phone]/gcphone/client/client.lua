local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')func=a.getInterface("gcphone")animApi=module("_core","client/functions/_Anims")src={}a.bindInterface("client_gcphone",src)b.addInterface("client_gcphone",src)local c={{code=172,event='ArrowUp'},{code=173,event='ArrowDown'},{code=174,event='ArrowLeft'},{code=175,event='ArrowRight'},{code=176,event='Enter'},{code=177,event='Backspace'}}local d=false;local e={}local f={}local g=''local h=false;local i=false;local j=false;local k=false;local l={}local m=false;local n=nil;function src.isUsingPhone()return d end;function hasPhone(o)if func.checkItemPhone()then o(true)end end;RegisterNetEvent("arrows:anims:gcphone")AddEventHandler("arrows:anims:gcphone",function(p,q)if d then return end;local r=GetPlayerPed(-1)if not IsPedInAnyVehicle(r)and GetEntityHealth(r)>100 then animApi.playAnim(true,{{p,q}},false)end end)Citizen.CreateThread(function()while true do Citizen.Wait(1)if IsControlJustPressed(1,311)then hasPhone(function(hasPhone)if hasPhone==true then PlaySound(-1,"Hang_Up","Phone_SoundSet_Michael",0,0,1)TooglePhone()end end)end;if d==true then for s,t in ipairs(c)do if IsControlJustPressed(1,t.code)then PlaySound(-1,"CLICK_BACK","WEB_NAVIGATION_SOUNDS_PHONE",0,0,1)SendNUIMessage({keyUp=t.event})end end;local u=i and not j;SetNuiFocus(u,u)k=true;DisableControlAction(0,243,true)else if k==true then PlaySound(-1,"CLICK_BACK","WEB_NAVIGATION_SOUNDS_PHONE",0,0,1)SetNuiFocus(false,false)k=false end end end end)RegisterNetEvent('gcPhone:setEnableApp')AddEventHandler('gcPhone:setEnableApp',function(v,w)SendNUIMessage({event='setEnableApp',appName=v,enable=w})end)function TakeAppel(x)TriggerEvent('gcphone:autoAcceptCall',x)end;RegisterNetEvent("gcPhone:forceOpenPhone")AddEventHandler("gcPhone:forceOpenPhone",function(y)if d==false then TooglePhone()end end)RegisterNetEvent("gcPhone:forceClosePhone")AddEventHandler("gcPhone:forceClosePhone",function()if d==true then TooglePhone()end end)RegisterNetEvent("gcPhone:myPhoneNumber")AddEventHandler("gcPhone:myPhoneNumber",function(y)g=y;SendNUIMessage({event='updateMyPhoneNumber',myPhoneNumber=g})end)RegisterNetEvent("gcPhone:contactList")AddEventHandler("gcPhone:contactList",function(z)SendNUIMessage({event='updateContacts',contacts=z})e=z end)RegisterNetEvent("gcPhone:allMessage")AddEventHandler("gcPhone:allMessage",function(A)SendNUIMessage({event='updateMessages',messages=A})f=A end)RegisterNetEvent("gcPhone:receiveMessage")AddEventHandler("gcPhone:receiveMessage",function(B)SendNUIMessage({event='newMessage',message=B})if B.owner==0 then TriggerEvent("vrp_sound:source",'message',1.0)end end)function addContact(C,D)TriggerServerEvent('gcPhone:addContact',C,D)end;function deleteContact(D)TriggerServerEvent('gcPhone:deleteContact',D)end;function sendMessage(D,B)TriggerServerEvent('gcPhone:sendMessage',D,B)end;function deleteMessage(E)TriggerServerEvent('gcPhone:deleteMessage',E)for F,G in ipairs(f)do if G.id==E then table.remove(f,F)SendNUIMessage({event='updateMessages',messages=f})return end end end;function deleteMessageContact(D)TriggerServerEvent('gcPhone:deleteMessageNumber',D)end;function deleteAllMessage()TriggerServerEvent('gcPhone:deleteAllMessage')end;function setReadMessageNumber(D)TriggerServerEvent('gcPhone:setReadMessageNumber',D)for F,G in ipairs(f)do if G.transmitter==D then G.isRead=1 end end end;function requestAllMessages()TriggerServerEvent('gcPhone:requestAllMessages')end;function requestAllContact()TriggerServerEvent('gcPhone:requestAllContact')end;local H=false;local I=false;RegisterNetEvent("gcPhone:waitingCall")AddEventHandler("gcPhone:waitingCall",function(x,J)SendNUIMessage({event='waitingCall',infoCall=x,initiator=J})if J==true then PhonePlayCall()if d==false then TooglePhone()end end end)RegisterNetEvent("gcPhone:acceptCall")AddEventHandler("gcPhone:acceptCall",function(x,J)if I==false and h==false then I=true;NetworkSetVoiceChannel(x.id+1)NetworkSetTalkerProximity(0.0)end;if d==false then TooglePhone()end;PhonePlayCall()SendNUIMessage({event='acceptCall',infoCall=x,initiator=J})end)RegisterNetEvent("gcPhone:rejectCall")AddEventHandler("gcPhone:rejectCall",function(x)if I==true then I=false;Citizen.InvokeNative(0xE036A705F989E049)NetworkSetTalkerProximity(2.5)end;PhonePlayText()SendNUIMessage({event='rejectCall',infoCall=x})end)RegisterNetEvent("gcPhone:historiqueCall")AddEventHandler("gcPhone:historiqueCall",function(K)SendNUIMessage({event='historiqueCall',historique=K})end)function startCall(L,M,N)TriggerServerEvent('gcPhone:startCall',L,M,N)end;function acceptCall(x,O)TriggerServerEvent('gcPhone:acceptCall',x,O)end;function rejectCall(x)TriggerServerEvent('gcPhone:rejectCall',x)end;function ignoreCall(x)TriggerServerEvent('gcPhone:ignoreCall',x)end;function requestHistoriqueCall()TriggerServerEvent('gcPhone:getHistoriqueCall')end;function appelsDeleteHistorique(D)TriggerServerEvent('gcPhone:appelsDeleteHistorique',D)end;function appelsDeleteAllHistorique()TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')end;RegisterNUICallback('startCall',function(P,o)startCall(P.numero,P.rtcOffer,P.extraData)o()end)RegisterNUICallback('acceptCall',function(P,o)acceptCall(P.infoCall,P.rtcAnswer)o()end)RegisterNUICallback('rejectCall',function(P,o)rejectCall(P.infoCall)o()end)RegisterNUICallback('ignoreCall',function(P,o)ignoreCall(P.infoCall)o()end)RegisterNUICallback('notififyUseRTC',function(Q,o)h=Q;if h==true and I==true then I=false;Citizen.InvokeNative(0xE036A705F989E049)NetworkSetTalkerProximity(2.5)end;o()end)RegisterNUICallback('onCandidates',function(P,o)TriggerServerEvent('gcPhone:candidates',P.id,P.candidates)o()end)RegisterNetEvent("gcPhone:candidates")AddEventHandler("gcPhone:candidates",function(R)SendNUIMessage({event='candidatesAvailable',candidates=R})end)RegisterNetEvent('gcphone:autoCall')AddEventHandler('gcphone:autoCall',function(S,N)if S~=nil then SendNUIMessage({event="autoStartCall",number=S,extraData=N})end end)RegisterNetEvent('gcphone:autoCallNumber')AddEventHandler('gcphone:autoCallNumber',function(P)TriggerEvent('gcphone:autoCall',P.number)end)RegisterNetEvent('gcphone:autoAcceptCall')AddEventHandler('gcphone:autoAcceptCall',function(x)SendNUIMessage({event="autoAcceptCall",infoCall=x})end)RegisterNUICallback('log',function(P,o)o()end)RegisterNUICallback('focus',function(P,o)o()end)RegisterNUICallback('blur',function(P,o)o()end)RegisterNUICallback('reponseText',function(P,o)local T=P.limit or 255;local U=P.text or''DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","",U,"","","",T)while UpdateOnscreenKeyboard()==0 do DisableAllControlActions(0)Citizen.Wait(1)end;if GetOnscreenKeyboardResult()then U=GetOnscreenKeyboardResult()end;o(json.encode({text=U}))end)RegisterNUICallback('getMessages',function(P,o)o(json.encode(f))end)RegisterNUICallback('sendMessage',function(P,o)if P.message=='%pos%'then local V=GetEntityCoords(PlayerPedId())P.message='GPS: '..V.x..', '..V.y end;TriggerServerEvent('gcPhone:sendMessage',P.phoneNumber,P.message)end)RegisterNUICallback('deleteMessage',function(P,o)deleteMessage(P.id)o()end)RegisterNUICallback('deleteMessageNumber',function(P,o)deleteMessageContact(P.number)o()end)RegisterNUICallback('deleteAllMessage',function(P,o)deleteAllMessage()o()end)RegisterNUICallback('setReadMessageNumber',function(P,o)setReadMessageNumber(P.number)o()end)RegisterNUICallback('addContact',function(P,o)TriggerServerEvent('gcPhone:addContact',P.display,P.phoneNumber)end)RegisterNUICallback('updateContact',function(P,o)TriggerServerEvent('gcPhone:updateContact',P.id,P.display,P.phoneNumber)end)RegisterNUICallback('deleteContact',function(P,o)TriggerServerEvent('gcPhone:deleteContact',P.id)end)RegisterNUICallback('getContacts',function(P,o)o(json.encode(e))end)RegisterNUICallback('setGPS',function(P,o)SetNewWaypoint(tonumber(P.x),tonumber(P.y))o()end)RegisterNUICallback('callEvent',function(P,o)local W=P.eventName or''if string.match(W,'gcphone')then if P.data~=nil then TriggerEvent(P.eventName,P.data)else TriggerEvent(P.eventName)end else print('Event not allowed')end;o()end)RegisterNUICallback('useMouse',function(X,o)i=X end)RegisterNUICallback('deleteALL',function(P,o)TriggerServerEvent('gcPhone:deleteALL')o()end)function TooglePhone()d=not d;SendNUIMessage({show=d})if d==true then PhonePlayIn()else PhonePlayOut()end end;RegisterNUICallback('closePhone',function(P,o)d=false;SendNUIMessage({show=false})PhonePlayOut()o()end)RegisterNUICallback('appelsDeleteHistorique',function(P,o)appelsDeleteHistorique(P.numero)o()end)RegisterNUICallback('appelsDeleteAllHistorique',function(P,o)appelsDeleteAllHistorique(P.infoCall)o()end)RegisterNUICallback('setIgnoreFocus',function(P,o)j=P.ignoreFocus;o()end)