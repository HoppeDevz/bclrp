local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')APICKF=b.getInterface('API')cAPI=a.getInterface('cAPI')hpp={}a.bindInterface("hpp_loot",hpp)local c=a.getInterface("hpp_loot")Citizen.CreateThread(function()while true do Citizen.Wait(5*60*1000)collectgarbage("count")collectgarbage("collect")end end)local d={}function hpp.removeSourceInArray(e)for f=1,#d do if d[f]==e then table.remove(d,f)end end end;RegisterNetEvent("hoppe:loot:openMenu")AddEventHandler("hoppe:loot:openMenu",function(g)local h=source;local i=APICKF.getUserFromSource(h)local j=i:getCharacter()local k=j.id;local l=g;if l~=nil and l~=0 then if not c.isDead(l)then if not j:hasGroup("pmesp")then return TriggerClientEvent("Notify",h,"negado","O jogador não está morto!")end end;if#d>0 then for f=1,#d do if d[f]==l then return TriggerClientEvent("Notify",h,"importante","Já estão roubando esta pessoa!")end;table.insert(d,1,l)end else table.insert(d,1,l)end;local m=APICKF.getUserFromSource(l)local n=m:getCharacter()local o=n.id;local p=MySQL.Sync.fetchAll("SELECT * FROM inventories WHERE charid = @charid",{["@charid"]=o})local q=MySQL.Sync.fetchAll("SELECT * FROM inventories WHERE charid = @charid",{["@charid"]=k})print('TargetSource',l)TriggerClientEvent("Notify",l,"importante","O Jogador "..j.id.." está lhe revistando ")TriggerClientEvent("hoppe:client:open:menu",h,p,json.decode(p[1].items),json.decode(q[1].items),l)end end)function hpp.lootItem(r,s,t)local h=source;local i=APICKF.getUserFromSource(h)local j=i:getCharacter()local k=j.id;local m=APICKF.getUserFromSource(t)local n=m:getCharacter()local u=j.Inventory:getCapacity()-j.Inventory:getWeight()local v=APICKF.getItemDataFromId(r)local w=v:getWeight()*parseInt(s)if u>w then j:addItem(r,parseInt(s))n:removeItem(r,parseInt(s))TriggerClientEvent("Notify",h,"sucesso","Roubou x "..s.." "..v.name.." ")TriggerClientEvent("Notify",t,"importante","Lhe roubaram x "..s.." "..v.name.." ")else TriggerClientEvent("Notify",h,"negado","Espaço insuficiente!")return false end end