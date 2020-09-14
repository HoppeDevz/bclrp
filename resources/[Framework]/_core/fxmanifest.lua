fx_version 'adamant'
game 'gta5'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
	'libs/utils.lua',
	---------------------
	'config/Items.lua',
	'config/CraftableItems.lua', 
	'config/Garages.lua',
	'config/Weapons.lua',
	'config/Language.lua',
	'config/CKF.lua',
	---------------------
	'client/_Main.lua',
	---------------------
	'client/functions/_Utils.lua',
	'client/functions/_Camera.lua',
	'client/functions/_Character.lua',
	'client/functions/_Inventory.lua',
	'client/functions/_Anims.lua',
	---------------------
	'client/game/_bNeeds.lua',
	--'client/game/_onDeath.lua',
	---------------------
	--'client/mapping/_IPLoader.lua',
}

server_scripts {
	'libs/utils.lua',
	---------------------
	'config/Language.lua',
	'config/Items.lua',
	'config/XPSystem.lua',
	'config/Chests.lua',
	'config/Permissions.lua',
	'config/CKF.lua',
	---------------------
	'server/_Main.lua',
	'server/Database.lua',
	'server/Auth.lua',
	'server/Gui.lua',
	-----------------------
	'server/class/Inventory.lua',
	'server/class/ItemData.lua',
	'server/class/Character.lua',
	'server/class/User.lua',
	'server/class/Chest.lua',
	'server/class/ShopItem.lua',
	'server/class/Posse.lua',
	-----------------------
	'server/manager/ItemDataManager.lua',
	'server/manager/CharacterManager.lua',
	'server/manager/PosseManager.lua',
	'server/manager/ChestManager.lua',
	'server/manager/NeedsManager.lua',
	'server/manager/MoneyController.lua'
}

files {
	'libs/utils.lua',
	'libs/Tunnel.lua',
	'libs/Proxy.lua',
	'libs/Tools.lua',
	'html/*',
	'html/img/*',
	'html/fonts/*',
	"loading/*"
}


loadscreen "loading/index.html"

ui_page 'html/index.html'
