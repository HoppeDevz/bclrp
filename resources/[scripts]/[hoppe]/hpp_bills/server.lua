local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_bills", hpp)

local hppC = Tunnel.getInterface("hpp_bills")

local cfgPermissions = module("_core", "config/Permissions")

API_Database = {}
local API = exports['GHMattiMySQL']

---------------------------------------------
---------------DATABASE SYSTEM---------------
---------------------------------------------
DBConnect = {
	driver = 'ghmattimysql',
	host = '127.0.0.1',
	database = 'ckf2',
	user = 'root',
	password = ''
}

local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false

function API_Database.registerDBDriver(name, on_init, on_prepare, on_query)
	if not db_drivers[name] then
		db_drivers[name] = {on_init, on_prepare, on_query}

		if name == DBConnect.driver then
			db_driver = db_drivers[name]

			local ok = on_init(DBConnect)
			if ok then
				db_initialized = true
				for _, prepare in pairs(cached_prepares) do
					on_prepare(table.unpack(prepare, 1, table.maxn(prepare)))
				end

				for _, query in pairs(cached_queries) do
					async(
						function()
							query[2](on_query(table.unpack(query[1], 1, table.maxn(query[1]))))
						end
					)
				end

				cached_prepares = nil
				cached_queries = nil
			else
				error('Conexão com o banco de dados perdida.')
			end
		end
	else
		error('Banco de dados registrado.')
	end
end

function API_Database.format(n)
	local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)', '%1.'):reverse()) .. right
end

function API_Database.prepare(name, query)
	prepared_queries[name] = true

	if db_initialized then
		db_driver[2](name, query)
	else
		table.insert(cached_prepares, {name, query})
	end
end

function API_Database.query(name, params, mode)
	if not prepared_queries[name] then
		error('query ' .. name .. " doesn't exist.")
	end

	if not mode then
		mode = 'query'
	end

	if db_initialized then
		return db_driver[3](name, params or {}, mode)
	else
		local r = async()
		table.insert(cached_queries, {{name, params or {}, mode}, r})
		return r:wait()
	end
end

function API_Database.execute(name, params)
	return API_Database.query(name, params, 'execute')
end

---------------------------------------------
---------------EXECUTE  SYSTEM---------------
---------------------------------------------
local queries = {}

local function on_init(cfg)
	return API ~= nil
end

local function on_prepare(name, query)
	queries[name] = query
end

local function on_query(name, params, mode)
	local query = queries[name]
	local _params = {}
	_params._ = true

	for k, v in pairs(params) do
		_params['@' .. k] = v
	end

	local r = async()

	if mode == 'execute' then
		API:QueryAsync(
			query,
			_params,
			function(affected)
				r(affected or 0)
			end
		)
	elseif mode == 'scalar' then
		API:QueryScalarAsync(
			query,
			_params,
			function(scalar)
				r(scalar)
			end
		)
	else
		API:QueryResultAsync(
			query,
			_params,
			function(rows)
				r(rows, #rows)
			end
		)
	end
	return r:wait()
end

Citizen.CreateThread(
	function()
		API:Query('SELECT 1')
		API_Database.registerDBDriver('ghmattimysql', on_init, on_prepare, on_query)
	end
)

API_Database.prepare('CKF_/createBill', 'INSERT INTO bills (charid, payQtd, toId, description) VALUES (@charid, @payQtd, @toId, @description)')
API_Database.prepare('CKF_/getAllBills', 'SELECT * FROM bills WHERE charid = @charid')
API_Database.prepare('CKF_/payBill', 'UPDATE bills SET status = "Pago" WHERE id = @id')

API_Database.prepare('CKF_/getBankMoneyByCharId', 'SELECT money FROM characters WHERE charid = @charid')
API_Database.prepare('CKF_/setBankMoneyByCharId', 'UPDATE characters SET money = @money WHERE charid = @charid')

function hpp.createBill(_id, _payQtd, _desc)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            API_Database.query('CKF_/createBill', { charid = _id, payQtd = _payQtd, toId = charid, description = _desc })
        end
    end
end

function hpp.getAllBills()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            local rows = API_Database.query('CKF_/getAllBills', { charid = charid })
            return rows
        end
    end
end

function hpp.payBill(_id, _payQtd, _toId)
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    if User then
        local Character = User:getCharacter()
        if Character then
            local charid = Character.id
            local bankMoney = API_Database.query('CKF_/getBankMoneyByCharId', { charid = charid })
            --print("bankMoney => "..bankMoney[1].money)
            if parseInt(bankMoney[1].money) >= parseInt(_payQtd) then
                local new_amount = parseInt(bankMoney[1].money) - parseInt(_payQtd)
                API_Database.query('CKF_/setBankMoneyByCharId', { charid = charid, money = new_amount })
                API_Database.query('CKF_/payBill', { id = _id })

                local tplayer = APICKF.getUserFromUserId(parseInt(_toId)):getSource()
				--TriggerClientEvent("bills-notify", tplayer, "<b>~r~[AVISO] ~w~Você recebeu um pagamento de um boleto de ~g~R$".._payQtd.." reais")
				TriggerClientEvent("Notify", tplayer, "sucesso", "Você recebeu um pagamento de um boleto de".._payQtd.." reais.")

                local nbankMoney = API_Database.query('CKF_/getBankMoneyByCharId', { charid = parseInt(_toId) })
                local n_value = parseInt(nbankMoney[1].money) + parseInt(_payQtd)
                API_Database.query('CKF_/setBankMoneyByCharId', { charid = parseInt(_toId), money = n_value })

                return { ["error"] = false, ["payQtd"] = _payQtd }
            else
                return { ["error"] = true, ["reason"] = "don't have money to pay this bill" }
            end
        end
    end
end
