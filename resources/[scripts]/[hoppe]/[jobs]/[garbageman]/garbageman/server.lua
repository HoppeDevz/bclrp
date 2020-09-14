local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("garbageman", hpp)

function hpp.giveTrashItem()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = parseInt(Character.id)

            local rest = Character.Inventory:getCapacity() - Character.Inventory:getWeight()
			local ItemData = APICKF.getItemDataFromId("generic_trash")
			local itemWeight = ItemData:getWeight()

			if parseInt(rest) > parseInt(itemWeight) then
                Character:addItem("generic_trash", parseInt(math.random(1,3)))
                return { error = false }
            else
                return { error = true, reason = "don't have space in backpack" }
            end
        end
    end
   
end