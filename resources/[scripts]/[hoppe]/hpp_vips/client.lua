local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')local c=a.getInterface("hpp_vips")hppC={}a.bindInterface("hpp_vips",hppC)API=b.getInterface('API')cAPI=a.getInterface('cAPI')Citizen.CreateThread(function()while true do Citizen.Wait(5*60*1000)collectgarbage("count")collectgarbage("collect")end end)animApi=module("_core","client/functions/_Anims")local d={["vip30"]=600,["vip50"]=1000,["vip100"]=1800}Citizen.CreateThread(function()while true do Citizen.Wait(30*60000)local e=c.isVip()if e then if e.isVip then for f,g in pairs(d)do if f==e.vip then c.giveVipPayday(g)TriggerEvent("Notify","sucesso","Você recebeu seu salário vip! R$"..g.."!")end end end end end end)local h={["pmesp"]=3500,["samu"]=4500,["mecanico"]=3500}RegisterCommand("cor",function(i,j)local e=c.isVip()if e.vip=="vip100"or e.vip=="vip50"or c.isGroup("admin")then local k=parseInt(j[1])local l=PlayerPedId()local m=GetSelectedPedWeapon(l)if k>=0 then SetPedWeaponTintIndex(l,m,k)end else return TriggerEvent("Notify","negado","Você não é vip!")end end,false)RegisterCommand("attachs",function(i,j)local l=PlayerPedId()if c.isGroup("pmesp")or c.isHaveWeaponModifier()then if GetSelectedPedWeapon(l)==GetHashKey("WEAPON_COMBATPISTOL")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_SMG")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_COMBATPDW")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_SCOPE_SMALL"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_PUMPSHOTGUN_MK2")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_CARBINERIFLE")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_CARBINERIFLE_MK2")then local n=getWeapons()GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_02"))local l=PlayerPedId()local o=GetHashKey("WEAPON_CARBINERIFLE_MK2")for p,q in pairs(n)do local o=GetHashKey(p)if p=="WEAPON_CARBINERIFLE_MK2"then print("give weapon ammo",o,q.ammo)Citizen.InvokeNative(0xBF0FD6E56C964FCB,l,o,q.ammo or 0,false,false)Citizen.InvokeNative(0x5FD1E1F011E76D7E,l,GetPedAmmoTypeFromWeapon(l,o),q.ammo)end end elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_PUMPSHOTGUN_MK2")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_ASSAULTRIFLE_MK2")then local n=getWeapons()GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))local l=PlayerPedId()local o=GetHashKey("WEAPON_ASSAULTRIFLE_MK2")for p,q in pairs(n)do local o=GetHashKey(p)if p=="WEAPON_ASSAULTRIFLE_MK2"then print("give weapon ammo",o,q.ammo)Citizen.InvokeNative(0xBF0FD6E56C964FCB,l,o,q.ammo or 0,false,false)Citizen.InvokeNative(0x5FD1E1F011E76D7E,l,GetPedAmmoTypeFromWeapon(l,o),q.ammo)end end elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_MICROSMG")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_MICROSMG"),GetHashKey("COMPONENT_AT_PI_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_MICROSMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_ASSAULTRIFLE")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_PISTOL_MK2")then local n=getWeapons()GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_RAIL"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_FLSH_02"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_COMP"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_PISTOL_MK2_CLIP_TRACER"))local l=PlayerPedId()local o=GetHashKey("WEAPON_PISTOL_MK2")for p,q in pairs(n)do local o=GetHashKey(p)if p=="WEAPON_PISTOL_MK2"then print("give weapon ammo",o,q.ammo)Citizen.InvokeNative(0xBF0FD6E56C964FCB,l,o,q.ammo or 0,false,false)Citizen.InvokeNative(0x5FD1E1F011E76D7E,l,GetPedAmmoTypeFromWeapon(l,o),q.ammo)end end elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_PISTOL_MK2")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_RAIL"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_FLSH_02"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_COMP"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_ASSAULTSMG")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))GiveWeaponComponentToPed(l,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))elseif GetSelectedPedWeapon(l)==GetHashKey("WEAPON_PISTOL")then GiveWeaponComponentToPed(l,GetHashKey("WEAPON_PISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))end end end)local r=module("hpp_vips","weapon_types")RegisterCommand("weapons",function(i,j,s)local n=getWeapons()for f,g in pairs(n)do print(f,json.encode(g))end end)function getWeapons()local t=PlayerPedId()local u={}local n={}for f,g in pairs(r)do local o=GetHashKey(g)if HasPedGotWeapon(t,o)then local p={}n[g]=p;local v=Citizen.InvokeNative(0x7FEAD38B326B9F74,t,o)if u[v]==nil then u[v]=true;p.ammo=GetAmmoInPedWeapon(t,o)else p.ammo=0 end end end;return n end;Citizen.CreateThread(function()while true do Citizen.Wait(30*60*1000)for f,g in pairs(h)do print("k",f)print("v",g)if c.isGroup(f)then TriggerEvent("hoppe:toogle:payday",g)end end end end)RegisterNetEvent("hpp:payday:givemoney")AddEventHandler("hpp:payday:givemoney",function(w)c.givePayday(parseInt(w))TriggerEvent("Notify","sucesso","Você recebeu seu salário de R$"..w.."")end)