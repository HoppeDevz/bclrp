local cfg = {}

cfg.start = {
    ["start_mission"] = { -139.819, -2385.119, 6.000 },
    ["data"] = {
        ["Entrega de Óleo"] = { 
            ["truck"] = "Hauler",
            ["truck_spawn"] = { -141.16860961914, -2410.3168945313, 5.9999985694885, 177.322 },
            ["trucker"] = "armytanker",
            ["trucker_spawn"] = { -145.21249389648,-2415.744140625,5.9999985694885, 179.156 },

            ["delivery_point"] = { 790.50701904297,1279.0280761719,360.28985595703 }
        },

        ["Entrega de Madeira"] = { 
            ["truck"] = "Hauler",
            ["truck_spawn"] = { -141.16860961914, -2410.3168945313, 5.9999985694885, 177.322 },
            ["trucker"] = "trailerlogs",
            ["trucker_spawn"] = { -145.21249389648,-2415.744140625,5.9999985694885, 179.156 },

            ["delivery_point"] = { -807.77801513672,5411.18359375,33.967391967773 }
        }
    }
}

cfg.blip = {
    ["Central | Caminhoneiro"] = {
        _coords = { -139.95275878906,-2385.498046875,6.0585041046143 },
        _blipSprite = 318,
        _blipColor = 4
    }
}

return cfg