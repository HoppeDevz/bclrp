local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')APICKF=b.getInterface('API')cAPI=a.getInterface('cAPI')hpp={}a.bindInterface("hpp_craft",hpp)local c=a.getInterface("hpp_craft")Citizen.CreateThread(function()while true do Citizen.Wait(5*60*1000)collectgarbage("count")collectgarbage("collect")end end)local d=module("_core","config/Permissions")API_Database={}local e=exports['GHMattiMySQL']DBConnect={driver='ghmattimysql',host='127.0.0.1',database='ckf2',user='root',password=''}local f={}local g;local h={}local i={}local j={}local k=false;function API_Database.registerDBDriver(l,m,n,o)if not f[l]then f[l]={m,n,o}if l==DBConnect.driver then g=f[l]local p=m(DBConnect)if p then k=true;for q,r in pairs(h)do n(table.unpack(r,1,table.maxn(r)))end;for q,s in pairs(i)do async(function()s[2](o(table.unpack(s[1],1,table.maxn(s[1]))))end)end;h=nil;i=nil else error('Conexão com o banco de dados perdida.')end end else error('Banco de dados registrado.')end end;function API_Database.format(t)local u,v,w=string.match(t,'^([^%d]*%d)(%d*)(.-)$')return u..v:reverse():gsub('(%d%d%d)','%1.'):reverse()..w end;function API_Database.prepare(l,s)j[l]=true;if k then g[2](l,s)else table.insert(h,{l,s})end end;function API_Database.query(l,x,y)if not j[l]then error('query '..l.." doesn't exist.")end;if not y then y='query'end;if k then return g[3](l,x or{},y)else local z=async()table.insert(i,{{l,x or{},y},z})return z:wait()end end;function API_Database.execute(l,x)return API_Database.query(l,x,'execute')end;local A={}local function m(B)return e~=nil end;local function n(l,s)A[l]=s end;local function o(l,x,y)local s=A[l]local C={}C._=true;for D,E in pairs(x)do C['@'..D]=E end;local z=async()if y=='execute'then e:QueryAsync(s,C,function(F)z(F or 0)end)elseif y=='scalar'then e:QueryScalarAsync(s,C,function(G)z(G)end)else e:QueryResultAsync(s,C,function(H)z(H,#H)end)end;return z:wait()end;Citizen.CreateThread(function()e:Query('SELECT 1')API_Database.registerDBDriver('ghmattimysql',m,n,o)end)API_Database.prepare('CKF_/getInfoDataByCharId','SELECT * FROM characters WHERE charid = @charid')API_Database.prepare('CKF_/setNewCapacity','UPDATE inventories SET capacity = @newcapacity WHERE charid = @charid')function hpp.checkPerm(I)local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()local M=L.id;local H=API_Database.query('CKF_/getInfoDataByCharId',{charid=M})local N=json.decode(H[1].groups)for D,E in pairs(N)do for O,P in pairs(d)do if D==O then if P.inheritance==I then return true end end end end;return false end end;function hpp.checkCraft(Q,R,S,T)local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()if L then local M=L.id;local U=L.Inventory:getCapacity()-L.Inventory:getWeight()local V=APICKF.getItemDataFromId(S)local W=V:getWeight()if parseInt(U)>parseInt(W)*parseInt(T)then if Q then if L:getItemAmount(Q)>=R then L:removeItem(Q,parseInt(R))print("_GiveItem => "..S,"_GiveQtd => "..T)L:addItem(S,parseInt(T))else return{["error"]=true,["reason"]="does not have a necessary raw material"}end else L:addItem(S,parseInt(T))end;local X=V:getName()return{["error"]=false,["giveItem"]=X,["giveQtd"]=T}else return{["error"]=true,["reason"]="there is no free space in the inventory"}end end end end;function hpp.checkCraftWeapon(Y,Z,_)local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()if L then local M=L.id;if L:getItemAmount("steel")>=parseInt(_)then L:removeItem("steel",parseInt(_))L:addItem(Z,1)return{error=false}else return{error=true,reason="does not have a necessary raw material"}end end end end;function hpp.getInvCapacity()local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()if L then local M=L.id;return parseInt(L.Inventory:getCapacity())end end end;function hpp.hasGroup(a0)local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()if L then local M=L.id;return L:hasGroup(a0)end end end;function hpp.remBag()local J=source;local K=APICKF.getUserFromSource(J)if K then local L=K:getCharacter()if L then local M=L.id;if parseInt(L.Inventory:getCapacity())==25 then if parseInt(L.Inventory:getWeight())>5 then return false end;L:addItem("backpack00",1)TriggerEvent("hoppe:save:newcapacity",5,M)L.Inventory:setCapacity(5)return true elseif parseInt(L.Inventory:getCapacity())==30 then if parseInt(L.Inventory:getWeight())>5 then return false end;L:addItem("backpack01",1)TriggerEvent("hoppe:save:newcapacity",5,M)L.Inventory:setCapacity(5)return true elseif parseInt(L.Inventory:getCapacity())==38 then if parseInt(L.Inventory:getWeight())>5 then return false end;L:addItem("backpack02",1)TriggerEvent("hoppe:save:newcapacity",5,M)L.Inventory:setCapacity(5)return true elseif parseInt(L.Inventory:getCapacity())==5 then return true end else return 0 end else return 0 end end;RegisterNetEvent("hoppe:save:newcapacity")AddEventHandler("hoppe:save:newcapacity",function(a1,a2)API_Database.query("CKF_/setNewCapacity",{newcapacity=parseInt(a1),charid=a2})end)