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
----------	USER THIGNS -------------
API_Database.prepare('CKF_/CreateUser', 'INSERT INTO users(identifier, name, banned) VALUES(@identifier, @name, 0); SELECT LAST_INSERT_ID() AS id')
API_Database.prepare('CKF_/SelectUser', 'SELECT * from users WHERE identifier = @identifier')
API_Database.prepare('CKF_/BannedUser', 'SELECT banned from users WHERE user_id = @user_id')
API_Database.prepare('CKF_/SetBanned', 'UPDATE users SET banned = 1 WHERE user_id = @user_id')
API_Database.prepare('CKF_/Whitelisted', 'SELECT * from whitelist WHERE identifier = @identifier')

-------- CHARACTER THIGNS -----------
API_Database.prepare('CKF_/CreateCharacter', "INSERT INTO characters(user_id, charid, characterName, age, skin, clothes, money, groups, phone) VALUES (@user_id, @charid, @charName, @charAge, @charSkin, @clothes, @money, '{\"user\":true}', @phone); SELECT LAST_INSERT_ID() AS id")
API_Database.prepare('CKF_/GetCharacters', 'SELECT * from characters WHERE user_id = @user_id')
API_Database.prepare('CKF_/GetCharacter', 'SELECT * from characters WHERE charid = @charid')
API_Database.prepare('CKF_/DeleteCharacter', 'DELETE FROM characters WHERE charid = @charid')
API_Database.prepare('CKF_/GetUserIdByCharId', 'SELECT user_id from characters WHERE charid = @charid')
API_Database.prepare('CKF_/GetCharNameByCharId', 'SELECT characterName from characters WHERE charid = @charid')
API_Database.prepare('CKF_/UpdateLevel', 'UPDATE characters SET level = @level WHERE charid = @charid')
API_Database.prepare('CKF_/UpdateXP', 'UPDATE characters SET xp = @xp WHERE charid = @charid')
API_Database.prepare('CKF_/CheckNumberPhoneIsExist', 'SELECT * FROM characters WHERE phone = @phone')

-------- CHARACTER DATATABLE --------
API_Database.prepare('CKF_/SetCData', 'CALL setData(@target, @key, @value, @charid)')
API_Database.prepare('CKF_/GetCData', 'CALL getData(@target, @charid, @key)')
API_Database.prepare('CKF_/RemCData', 'CALL remData(@target, @key, @charid)')
API_Database.prepare('CKF_/SetCWeaponData', 'UPDATE characters SET weapons = @weapons WHERE charid = @charid')
-------- INVENTORY THINGS -----------
API_Database.prepare('CKF_/Inventory', 'CALL inventories(@id, @charid, @itemName, @itemCount, @typeInv);')
API_Database.prepare('CKF_/ForcedInventory', "INSERT INTO inventories(id, capacity, items) VALUES (@id, @capacity, @items);")

---------- HORSE THINGS -------------
API_Database.prepare('CKF_/CreatePosse', 'INSERT INTO posses(charid, members, name) VALUES (@charid, @members, @name); SELECT LAST_INSERT_ID() AS id')
API_Database.prepare('CKF_/GetPosseById', 'SELECT * from posses WHERE id = @id')

---------- CHEST QUERIES -------------
API_Database.prepare('CKF_/GetChests', 'SELECT * from chests')
API_Database.prepare('CKF_/CreateChest', "INSERT INTO chests(charid, position, type, capacity) VALUES (@charid, @position, @type, @capacity); SELECT LAST_INSERT_ID() AS id")
API_Database.prepare('CKF_/CreateStaticChest', "INSERT INTO chests(position, type, capacity) VALUES (@position, @type, @capacity); SELECT LAST_INSERT_ID() AS id")

API_Database.prepare('CKF_/MoneyUpdate', "UPDATE characters SET money = @money WHERE charid = @charid")
API_Database.prepare('CKF_/GetMoney', 'SELECT money FROM characters WHERE charid = @charid')
API_Database.prepare('CKF_/UpdateCharHealth', 'UPDATE characters SET health = @health WHERE charid = @charid')
