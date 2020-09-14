local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "water", quantidade = 1, compra = 150},
	{ item = "bread", quantidade = 1, compra = 150},
	{ item = "energydrink", quantidade = 1, compra = 350},
	{ item = "backpack00", quantidade = 1, compra = 4000},
	{ item = "backpack01", quantidade = 1, compra = 6000},
	{ item = "radio", quantidade = 1, compra = 2000},
	{ item = "clothes", quantidade = 1, compra = 5000},
	{ item = "phone", quantidade = 1, compra = 3000}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("comprar-mercearia")
AddEventHandler("comprar-mercearia",function(item)
	local _source = source
	local User = API.getUserFromSource(_source)
	if User then
		local Character = User:getCharacter()
		if Character then
			for k,v in pairs(valores) do
				if item == v.item then
					local rest = Character.Inventory:getCapacity() - Character.Inventory:getWeight()
					local ItemData = API.getItemDataFromId(v.item)
					local itemWeight = ItemData:getWeight()

					if parseInt(rest) > parseInt(itemWeight) then
						if Character:getMoney() >= parseInt(v.compra) then
							Character:getInventory():addItem(item ,parseInt(v.quantidade))
							Character:removeMoney(parseInt(v.compra))
							--TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..(v.item).."</b> por <b>$"..(parseInt(v.compra)).." Dólares</b>.")
							--TriggerClientEvent("mercadinho-notify", _source, "<b>~r~[AVISO] ~w~Comprou <b>"..parseInt(v.quantidade).."x "..(v.item).."</b> por <b>$"..(parseInt(v.compra)).." Dólares.</b>")
							TriggerClientEvent("Notify", _source, "sucesso", "Comprou x"..parseInt(v.quantidade).." "..(ItemData.name).." por R$"..(parseInt(v.compra)).."")
						else
							TriggerClientEvent("Notify", _source, "negado", "Você não tem dinheiro suficiente!")
						end
					else
						--TriggerClientEvent("mercadinho-notify", _source, "<b>~r~[AVISO] ~w~Espaço insuficiente.</b>")
						TriggerClientEvent("Notify", _source, "negado", "Espaço insuficiente!")
					end
				end
			end
		end
	end
end)