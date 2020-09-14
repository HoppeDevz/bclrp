Config_Permissions = {
    ["admin"] = {
        type = "staff",
        inheritance = "admin"
    },
    ["moderator"] = {
        type = "staff",
        inheritance = "helper"
    },
    ["helper"] = {
        type = "staff"
    },
    ----------
    ["pmesp"] = {
        name = "Polícia Militar",
        type = "job",
        inheritance = "policePerm"
    },
    ["ft"] = {
        name = "Força Tática",
        type = "job",
        inheritance = "policePerm"
    },

    ["samu"] = {
        name = "Médico",
        type = "job",
        inheritance = "medicPerm"
    },

    ["mecanico"] = {
        name = "Mecânico",
        type = "job",
        inheritance = "mechPerm"
    },

    ["pcc"] = {
        name = "Verdes",
        type = "job",
        inheritance = "pccPerm"
    },

    ["ada"] = {
        name = "Amarelos",
        type = "job",
        inheritance = "adaPerm"
    },

    ["motoclub"] = {
        name = "MotoClube",
        type = "job",
        inheritance = "mcPerm"
    },

    ["mafia"] = {
        name = "Mafia",
        type = "job",
        inheritance = "mafiaPerm"
    },

    ["mureta"] = {
        name = "Mureta",
        type = "job",
        inheritance = "muretaPerm"
    },

    ["antena"] = {
        name = "Antena",
        type = "job",
        inheritance = "antenaPerm"
    },

    ["cv"] = {
        name = "Vermelhos",
        type = "job",
        inheritance = "cvPerm"
    }
}

return Config_Permissions
