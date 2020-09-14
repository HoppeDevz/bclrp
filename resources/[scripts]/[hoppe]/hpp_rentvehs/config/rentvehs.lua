local cfg = {}

cfg.rentgarages = {
    ["police"] = {
        _config = { 
            ["coords"] =  { ["x"] = 457.64, ["y"] = -1009.22, ["z"] = 28.30 },
            ["spawnloc"] = { ["x"] = 448.95, ["y"] = -1021.08, ["z"] = 28.42, ["h"] = 100.00 },
            ["text3d"] = "GARAGEM PM",
            ["headerImg"] = "policia-militar-sp-logo",
            ["perm"] = "policePerm"
        },
        ["vehicles"] = {
            ["policiabmwr1200"] = { "BMWR 1200", "https://i.imgur.com/o3SRcau.png" },
            ["policiacharger2018"] = { "Policia Charger", "https://i.imgur.com/6RhmjD3.png" },
            ["policiasilverado"] = { "Policia Silverado", "https://i.imgur.com/qofMPiV.png" },
            ["policiatahoe"] = { "Policia Tahoe", "https://i.imgur.com/GsoKEQe.png" },
            ["policiataurus"] = { "Policia Taurus", "https://i.imgur.com/bJwEB5M.png" },
            ["policiavictoria"] = { "Policia Victoria", "https://i.imgur.com/OFfgKqR.png" },
            ["gtr"] = { "Policia GTR", "https://cdn.discordapp.com/attachments/746426603780702238/747532340544143430/unknown.png" }
        }
    },
    ["medics"] = {
        _config = {
            ["coords"] =  { ["x"] = 296.94, ["y"] = -603.23, ["z"] = 43.30 },
            ["spawnloc"] = { ["x"] = 292.11, ["y"] = -609.75, ["z"] = 43.37 },
            ["text3d"] = "GARAGEM SAMU",
            ["headerImg"] = "samu-sp-logo",
            ["perm"] = "medicPerm"
        },
        ["vehicles"] = {
            ["ambulance"] = { "Ambulância", "https://i.imgur.com/RPNwbV8.png" },
            ["sprintersamu"] = { "Sprinter", "https://i.imgur.com/yMulkCL.png" }
        }
    },
    ["mechanic"] = {
        _config = {
            ["coords"] =  { ["x"] = 956.37, ["y"] = -987.30, ["z"] = 40.12 },
            ["spawnloc"] = { ["x"] = 974.13, ["y"] = -1016.79, ["z"] = 41.05 },
            ["text3d"] = "GARAGEM MECÂNICO",
            ["headerImg"] = "mecanico-sp-logo",
            ["perm"] = "mechPerm"
        },
        ["vehicles"] = {
            ["flatbed"] = { "Flatbed", "https://vignette.wikia.nocookie.net/gtawiki/images/7/71/Flatbed-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161018180424" },
            ["towtruck2"] = { "Towtruck", "https://vignette.wikia.nocookie.net/gtawiki/images/2/24/Towtruck2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160625224220" }
        }
    },
    ["sedex"] = {
        _config = {
            ["coords"] =  { ["x"] = 63.49, ["y"] = 126.00, ["z"] = 79.18 },
            ["spawnloc"] = { ["x"] = 71.44, ["y"] = 122.44, ["z"] = 79.18 },
            ["text3d"] = "GARAGEM SEDEX",
            ["headerImg"] = "correios-sp-logo"
            --["perm"] = "mechPerm"
        },
        ["vehicles"] = {
            ["boxville4"] = { "Van Sedex", "https://img.gta5-mods.com/q85-w800/images/boxville-texture-sedex/e21512-GTA5%202015-06-18%2015-44-42.png" }
            --["towtruck2"] = { "Towtruck", "https://vignette.wikia.nocookie.net/gtawiki/images/2/24/Towtruck2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160625224220" }
        }
    },
    ["cet"] = {
        _config = {
            ["coords"] =  { ["x"] = 409.77, ["y"] = -1623.36, ["z"] = 29.29 },
            ["spawnloc"] = { ["x"] = 419.30, ["y"] = -1636.28, ["z"] = 29.29 },
            ["text3d"] = "GARAGEM CET",
            ["headerImg"] = "cet-logo-sp"
            --["perm"] = "mechPerm"
        },
        ["vehicles"] = {
            ["flatbed"] = { "Flatbed", "https://vignette.wikia.nocookie.net/gtawiki/images/7/71/Flatbed-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161018180424" },
        }
    },
    ["aeroport"] = {
        _config = {
            ["coords"] =  { ["x"] = -1027.86, ["y"] = -2726.66, ["z"] = 13.66 },
            ["spawnloc"] = { ["x"] = -1019.23, ["y"] = -2731.58, ["z"] = 13.66 },
            ["text3d"] = "ALUGUEL DE BIKE",
            ["headerImg"] = "rent-bike-logo"
            --["perm"] = "mechPerm"
        },
        ["vehicles"] = {
            ["bmx"] = { "BMX", "https://vignette.wikia.nocookie.net/gtawiki/images/6/64/BMX-GTAV-front.png/revision/latest?cb=20161018175629" },
        }
    },
    ["motorista"] = {
        _config = {
            ["coords"] =  { ["x"] = 472.30, ["y"] = -603.505, ["z"] = 28.499 }, -- 469.09,-618.18,28.49
            ["spawnloc"] = { ["x"] = 469.09, ["y"] = -618.18, ["z"] = 28.49 },
            ["text3d"] = "CENTRAL MOTORISTA",
            ["headerImg"] = "driver-central-logo"
            --["perm"] = "mechPerm"
        },
        ["vehicles"] = {
            ["coach"] = { "Ônibus", "https://vignette.wikia.nocookie.net/gtawiki/images/4/41/Dashound-GTAV-front.png/revision/latest?cb=20161018180031" },
        }
    }
}


return cfg