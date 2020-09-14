local cfg = {}

cfg.crafts = {

    --weed lab
    {   
        ["perm"] = "pccPerm",
        ["title"] = "Coletar Folha",
        ["coords"] = { 98.870,6343.412,31.411 },
        ["item"] = nil, ["itemqtd"] = nil, ["giveitem"] = "weed_seed", ["giveqtd"] = 1
    },

    {   
        ["perm"] = "pccPerm",
        ["title"] = "Processar Folha",
        ["coords"] = { 114.185,6360.459,32.305 },
        ["item"] = "weed_seed", ["itemqtd"] = 4, ["giveitem"] = "weed", ["giveqtd"] = 1
    },

    --cocaine lab
    {   
        ["perm"] = "cvPerm",
        ["title"] = "Coletar Ácido",
        ["coords"] = { -1108.41,4952.74,218.64 },
        ["item"] = nil, ["itemqtd"] = nil, ["giveitem"] = "cocaine_acid", ["giveqtd"] = 1
    },
    {   
        ["perm"] = "cvPerm",
        ["title"] = "Processar Ácido",
        ["coords"] = { -1107.70,4939.39,218.64 },
        ["item"] = "cocaine_acid", ["itemqtd"] = 4, ["giveitem"] = "cocaine", ["giveqtd"] = 1
    },

    --lsd lab
    {   
        ["perm"] = "adaPerm",
        ["title"] = "Coletar Ácido",
        ["coords"] = { 1504.94,6391.94,20.78 }, 
        ["item"] = nil, ["itemqtd"] = nil, ["giveitem"] = "acid_lisergic", ["giveqtd"] = 1
    },
    {   
        ["perm"] = "adaPerm",
        ["title"] = "Processar Ácido",
        ["coords"] = { 1493.131,6390.317,21.257 },
        ["item"] = "acid_lisergic", ["itemqtd"] = 4, ["giveitem"] = "lsd", ["giveqtd"] = 1
    },

    --ammo lab
    --[[{
        ["perm"] = "mcPerm",
        ["title"] = "Pegar Ferro",
        ["coords"] = { -575.231,5351.419,70.214 },
        ["item"] = nil, ["itemqtd"] = nil, ["giveitem"] = "iron", ["giveqtd"] = 8
    },]]
    {   
        ["perm"] = "mcPerm",
        ["title"] = "Processar Ferro",
        ["coords"] = { -164.09,6142.98,31.20 },
        ["item"] = "iron", ["itemqtd"] = 8, ["giveitem"] = "steel", ["giveqtd"] = 4
    },
    {   
        ["perm"] = "antenaPerm",
        ["title"] = "Processar Ferro",
        ["coords"] = { 747.62670898438,1301.0238037109,360.4638671875 },
        ["item"] = "iron", ["itemqtd"] = 8, ["giveitem"] = "steel", ["giveqtd"] = 4
    },

    --milk lab
    {
        ["perm"] = false,
        ["title"] = "Pegar Leite",
        ["coords"] = { 1534.23,6336.82,24.130 },
        ["item"] = nil, ["itemqtd"] = nil, ["giveitem"] = "milk_bottle", ["giveqtd"] = 1
    },
}

cfg.blips = {
    --[[{ 
        ["coords"] = { 97.06,6327.17,31.37 },
        ["title"] = "Fabricar Maconha", ["sprite"] = 140, ["color"] = 25 
    },
    { 
        ["coords"] = { -1096.06,4949.19,218.35 },
        ["title"] = "Fabricar Cocaina", ["sprite"] = 497, ["color"] = 4 
    },
    { 
        ["coords"] = { 1482.46,6392.28,22.97 },
        ["title"] = "Fabricar LSD", ["sprite"] = 51, ["color"] = 4 
    },]]
    { 
        ["coords"] = { -575.306,5351.274,70.214 },
        ["title"] = "Pegar Ferro", ["sprite"] = 478, ["color"] = 4 
    },
    --[[{
        ["coords"] = { -141.42,6141.12,31.57 },
        ["title"] = "Fabricar Armas", ["sprite"] = 150, ["color"] = 4
    },]]
    {
        ["coords"] = { 1534.23,6336.82,24.130 },
        ["title"] = "Coletar Leite", ["sprite"] = 238, ["color"] = 4
    }
}


--[[
    Name: a_c_cow
    Hash: 0xFCFA9E1E
]]
cfg.peds = {
    ["a_c_cow"] = { 1536.720, 6335.302, 24.075, 332.26, 0xFCFA9E1E }
}

--[[ 

    | weapon |  Price of Steel  |

]]

cfg.craftWeapons = {
    {
        ["coords"] = { -179.04814147949,6155.8881835938,31.206356048584 },
        ["data"] = {
            { ["name"] = "Five-Seven",  ["item"] = "weapon_pistol_mk2",    ["price"] = 200, ["imgUrl"] = "weapon_pistol_mk2" },
            { ["name"] = "AK-47",       ["item"] = "weapon_assaultrifle_mk2",  ["price"] = 650, ["imgUrl"] = "weapon_assaultrifle_mk2" },
            { ["name"] = "H&K G36C",       ["item"] = "weapon_specialcarbine_mk2",  ["price"] = 800, ["imgUrl"] = "weapon_specialcarbine_mk2" },
            { ["name"] = "Tec-9",       ["item"] = "weapon_machinepistol", ["price"] = 390, ["imgUrl"] = "weapon_machinepistol" },
            { ["name"] = "Shotgun",     ["item"] = "weapon_pumpshotgun",   ["price"] = 400, ["imgUrl"] = "weapon_pumpshotgun" }
        }
    },
    {
        ["coords"] = { 746.03,1296.83,360.29 },
        ["data"] = {
            { ["name"] = "Five-Seven",  ["item"] = "weapon_pistol_mk2",    ["price"] = 200, ["imgUrl"] = "weapon_pistol_mk2" },
            { ["name"] = "AK-47",       ["item"] = "weapon_assaultrifle_mk2",  ["price"] = 650, ["imgUrl"] = "weapon_assaultrifle_mk2" },
            { ["name"] = "H&K G36C",       ["item"] = "weapon_specialcarbine_mk2",  ["price"] = 800, ["imgUrl"] = "weapon_specialcarbine_mk2" },
            { ["name"] = "Tec-9",       ["item"] = "weapon_machinepistol", ["price"] = 390, ["imgUrl"] = "weapon_machinepistol" },
            { ["name"] = "Shotgun",     ["item"] = "weapon_pumpshotgun",   ["price"] = 400, ["imgUrl"] = "weapon_pumpshotgun" }
        }
    }
}

return cfg