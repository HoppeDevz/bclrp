function API.ShopItem(id, priceMoney, priceGold, levelRequired)
    local self = {}

    self.id = id
    self.name = API.getItemDataFromId(id):getName()
    self.priceMoney = priceMoney or 0
    self.priceGold = priceGold or 0
    self.levelRequired = levelRequired or 0

    self.getPriceMoney = function()
        return self.priceMoney or 0
    end
    self.getPriceGold = function()
        return self.priceGold or 0
    end

    self.getLevelRequired = function()
        return self.levelRequired or 0
    end

    return self
end
