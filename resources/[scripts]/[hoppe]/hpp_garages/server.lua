local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

APICKF = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

hpp = {}
Tunnel.bindInterface("hpp_garages", hpp)

API_Database = {}
local API = exports['GHMattiMySQL']

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5 * 60 * 1000)
        collectgarbage("count")
        collectgarbage("collect")
    end
end)

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

API_Database.prepare("CKF_/getAllVehicles", 'SELECT * FROM characters_vehicles WHERE charid = @charid')

API_Database.prepare("CKF_/getVehicleByPlate", 'SELECT * FROM characters_vehicles WHERE plate = @plate')

function hpp.getAllVehicles()
    local _source = source
    local User = APICKF.getUserFromSource(_source)
    local Character = User:getCharacter()
    local charid = Character.id

    local rows = API_Database.query('CKF_/getAllVehicles', { charid = charid })

    return rows
end

function hpp.getMods(_plate)
	local rows = API_Database.query('CKF_/getVehicleByPlate', { plate = _plate })
	if rows[1] then
		if rows[1].custom ~= nil then
			return json.decode(rows[1].custom)
		end
	else
		return false
	end
end

RegisterServerEvent("garages-tryLock")
AddEventHandler("garages-tryLock",function(nveh)
	TriggerClientEvent("garages-syncLock",-1,nveh)
end)

RegisterServerEvent("garages-tryUnLock")
AddEventHandler("garages-tryUnLock",function(nveh)
	TriggerClientEvent("garages-syncUnLock",-1,nveh)
end)