local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')APICKF=b.getInterface('API')cAPI=a.getInterface('cAPI')hpp={}a.bindInterface("hpp_contraband",hpp)Citizen.CreateThread(function()while true do Citizen.Wait(5*60*1000)collectgarbage("count")collectgarbage("collect")end end)function hpp.tryBuyItem(c,d)local e=source;local f=APICKF.getUserFromSource(e)if f then local g=f:getCharacter()if g then local h=g.id;local i=g.Inventory:getCapacity()-g.Inventory:getWeight()local j=APICKF.getItemDataFromId(c)local k=parseInt(j:getWeight())if g:getMoney()<parseInt(d)then return{error=true,reason="Dinheiro insuficiente!"}end;if i<k then return{error=true,reason="Espaço insuficiente!"}end;g:removeItem("generic_money",parseInt(d))g:addItem(c,1)TriggerClientEvent("Notify",e,"sucesso","Você comprou x1 "..j.name.."")return{error=false}end end end