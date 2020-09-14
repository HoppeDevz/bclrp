local cfg = {}

cfg.arsenal = {
    ["pmesp"] = {
        _config = { 
            ["coords"] = { ["x"] = 452.00057983398, ["y"] = -979.43121337891, ["z"] = 30.689607620239 },
            ["text3d"] = "ARSENAL PM",
            ["perm"] = "policePerm"
        },
        ["gunlist"] = {
            ["GLOCK-18"] = { "WEAPON_COMBATPISTOL", 240, 40 }, --Name | ItemName |  Give ammo amount | Size
            ["SMG"] = { "WEAPON_SMG", 240, 60 },
            ["M4A4"] = { "WEAPON_CARBINERIFLE_MK2", 240, 60 },
            ["M4A1"] = { "WEAPON_CARBINERIFLE", 240, 60 },
            ["TASER"] = { "WEAPON_STUNGUN", 300, 40 },
            ["SMG DE COMBATE"] = { "WEAPON_COMBATPDW", 240, 40 },
            ["PUMP SHOTGUN"] = { "WEAPON_PUMPSHOTGUN_MK2", 100, 40 },
            ["CASSETETE"] = { "WEAPON_NIGHTSTICK", 100, 40 }
        }
    }
}

return cfg