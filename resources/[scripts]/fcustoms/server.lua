local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_police", hpp)

local hppC = Tunnel.getInterface("hpp_police")

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

API_Database.prepare('CKF_/getInfoDataByCharId', 'SELECT * FROM characters WHERE charid = @charid')
API_Database.prepare('CKF_/updateModsVehicle', 'UPDATE characters_vehicles SET custom = @custom WHERE plate = @plate')
API_Database.prepare('CKF_/searchVehByPlate', 'SELECT * FROM characters_vehicles WHERE plate = @plate')

RegisterServerEvent("finalized:custom")
AddEventHandler("finalized:custom", function(_custom, _plate)
	local rows = API_Database.query('CKF_/searchVehByPlate', { plate = _plate })
	if rows[1] then
		if rows[1].plate then
			API_Database.query('CKF_/updateModsVehicle', { custom = json.encode(_custom), plate = _plate })
		end
	end
end)

function hpp.checkPerm(_Perm)
    local _source = source
	local User = APICKF.getUserFromSource(_source)
	if User then
		local Character = User:getCharacter()
		if Character then
			local charid = Character.id
			
			local rows = API_Database.query('CKF_/getInfoDataByCharId', { charid = charid })
			local groups = json.decode(rows[1].groups)

			for k,v in pairs(groups) do
				--print(k)
				for l,w in pairs(cfgPermissions) do
					if k == l then
						if w.inheritance == _Perm then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

RegisterServerEvent("customs:check")
AddEventHandler("customs:check",function(title, data, cost, value)
	local _source = tonumber(source)
	local User = APICKF.getUserFromSource(_source)
    local Character = User:getCharacter()
    local charid = Character.id
    --TriggerEvent('es:getPlayerFromId', source, function(user)
	    if Character:getMoney() >= tonumber(cost) then
	    	Character:removeMoney(tonumber(cost))
	    	TriggerClientEvent("customs:receive", _source, title, data, value)
	    else
	    	TriggerClientEvent("Notify", _source, "negado", "Você não tem dinheiro!")
	    end
	--end)
end)

RegisterServerEvent("customs:check2")
AddEventHandler("customs:check2",function(title, data, cost, value, back)
	local _source = tonumber(source)
	local User = APICKF.getUserFromSource(_source)
    local Character = User:getCharacter()
    local charid = Character.id
    --TriggerEvent('es:getPlayerFromId', source, function(user)
	    if Character:getMoney() >= tonumber(cost) then
	    	Character:removeMoney(tonumber(cost))
	    	TriggerClientEvent("customs:receive2", _source, title, data, value, back)
	    else
	    	TriggerClientEvent("Notify", _source, "negado", "Você não tem dinheiro!")
	    end
	--end)
end)

RegisterServerEvent("customs:check3")
AddEventHandler("customs:check3",function(title, data, cost, mod, back, name, wtype)
	local _source = tonumber(source)
	local User = APICKF.getUserFromSource(_source)
    local Character = User:getCharacter()
    local charid = Character.id
    --TriggerEvent('es:getPlayerFromId', source, function(user)
		if Character:getMoney() >= tonumber(cost) then
	    	Character:removeMoney(tonumber(cost))
	    	TriggerClientEvent("customs:receive3", _source, title, data, mod, back, name, wtype)
	    else
	    	TriggerClientEvent("Notify", _source, "negado", "Você não tem dinheiro!")
	    end
	--end)
end)

local tbl = {
[1] = {locked = false},
[2] = {locked = false},
[3] = {locked = false},
[4] = {locked = false},
[5] = {locked = false},
}

local ingarage = false
local currentgarage = nil
RegisterServerEvent('customs:lock')
AddEventHandler('customs:lock', function(b,garage)
	--ingarage = b
	--currentgarage = garage
	--tbl[tonumber(garage)].locked = b
	--TriggerClientEvent('customs:lock',-1,tbl)
	--print("LS Customs status: "..json.encode(tbl))
end)
RegisterServerEvent('customs:getgarageinfos')
AddEventHandler('customs:getgarageinfos', function()
TriggerClientEvent('customs:lock',-1,tbl)
--print("LS Customs status: "..json.encode(tbl))
end)

AddEventHandler('playerDropped', function()
	--if ingarage == true then
		--tbl[tonumber(currentgarage)].locked = false
		--TriggerClientEvent('customs:lock',-1,tbl)
		--print("LS Customs status: "..json.encode(tbl))
	--end
end)