local a=module('_core','libs/Tunnel')local b=module('_core','libs/Proxy')API=b.getInterface('API')cAPI=a.getInterface('cAPI')RegisterServerEvent('_inventory:showInventory')AddEventHandler('_inventory:showInventory',function()local c=source;local d=API.getUserFromSource(c)d:viewInventory()end)RegisterServerEvent('_inventory:funcItem')AddEventHandler('_inventory:funcItem',function(e)local c=source;local d=API.getUserFromSource(c)local f=d:getCharacter()local g=d:getCharacter():getInventory()if tonumber(e.Quantidade)==0 or tonumber(e.Quantidade)<0 then return end;if tonumber(f:getItemAmount(e.ItemName))<tonumber(e.Quantidade)then return end;if e.Tipo=="useItem"then g:useItem(c,e.ItemName,e.Quantidade)elseif e.Tipo=="sendItem"then g:sendItem(c,e.ItemName,e.Quantidade)elseif e.Tipo=="dropItem"then f:removeItem(e.ItemName,e.Quantidade)end end)