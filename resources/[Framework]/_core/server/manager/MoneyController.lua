

function API.updateMoneyCharID(_money, _charid)
    API_Database.query("CKF_/MoneyUpdate", { money = _money, charid = _charid })
end

function API.getMoney(_charid) 
    local rows = API_Database.query("CKF_/GetMoney", { charid = _charid })
    print(rows[0].money)
    return rows[0].money
end

function API.tryWithDrawMoney(_money, _charid)
    local amount = API.getMoney(_charid)
    if amount < _money then
        return false
    else
        --desconta o dinheiro e retorna true 
    end
end