animApi=module("_core","client/functions/_Anims")local a=nil;local b=0;local c="prop_amb_phone"local d="out"local e=nil;local f=nil;local g=false;local h={['cellphone@']={['out']={['text']='cellphone_text_in',['call']='cellphone_call_listen_base'},['text']={['out']='cellphone_text_out',['text']='cellphone_text_in',['call']='cellphone_text_to_call'},['call']={['out']='cellphone_call_out',['text']='cellphone_call_to_text',['call']='cellphone_text_to_call'}},['anim@cellphone@in_car@ps']={['out']={['text']='cellphone_text_in',['call']='cellphone_call_in'},['text']={['out']='cellphone_text_out',['text']='cellphone_text_in',['call']='cellphone_text_to_call'},['call']={['out']='cellphone_horizontal_exit',['text']='cellphone_call_to_text',['call']='cellphone_text_to_call'}}}function newPhoneProp()deletePhone()RequestModel(c)while not HasModelLoaded(c)do Citizen.Wait(10)end;b=CreateObject(GetHashKey(c),1.0,1.0,1.0,1,1,0)SetEntityCollision(b,false,false)AttachEntityToEntity(b,a,GetPedBoneIndex(a,28422),0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,0,2,1)Citizen.InvokeNative(0xAD738C3085FE7E11,b,true,true)end;RegisterCommand("gcdebug",function()deletePhone()end)function deletePhone()TriggerEvent("binoculos")if DoesEntityExist(b)then DetachEntity(b,true,true)Citizen.InvokeNative(0xAD738C3085FE7E11,b,true,true)SetEntityAsNoLongerNeeded(Citizen.PointerValueIntInitialized(b))DeleteEntity(b)end end;function PhonePlayAnim(i,j,k)if i~='out'and d=='out'then animApi.DeletarObjeto()end;if d==i and k~=true then return end;a=PlayerPedId()local j=j or false;local l="cellphone@"if IsPedInAnyVehicle(a,false)then l="anim@cellphone@in_car@ps"end;loadAnimDict(l)local m=h[l][d][i]if d~='out'then StopAnimTask(a,e,f,1.0)end;local n=50;if j==true then n=14 end;TaskPlayAnim(a,l,m,3.0,-1,-1,n,0,false,false,false)if i~='out'and d=='out'then Citizen.Wait(380)newPhoneProp()TriggerEvent("status:celular",true)SetCurrentPedWeapon(a,GetHashKey("WEAPON_UNARMED"),true)end;e=l;f=m;g=j;d=i;if i=='out'then Citizen.Wait(180)deletePhone()StopAnimTask(a,e,f,1.0)TriggerEvent("status:celular",false)end end;function PhonePlayOut()PhonePlayAnim('out')end;function PhonePlayText()PhonePlayAnim('text')end;function PhonePlayCall(j)PhonePlayAnim('call',j)end;function PhonePlayIn()if d=='out'then PhonePlayText()end end;function loadAnimDict(l)RequestAnimDict(l)while not HasAnimDictLoaded(l)do Citizen.Wait(10)end end