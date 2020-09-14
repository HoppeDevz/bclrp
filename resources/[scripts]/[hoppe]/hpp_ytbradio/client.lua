
local musics = {
    "https://www.youtube.com/embed/Jie46YL1ARI",
    "https://www.youtube.com/embed/MKi97BjQHWM"
}

local playtime = 0
local inplay = false
local currentMusic = ""

RegisterCommand("ytb", function(source, args, rawCommand)
    print(musics[ tonumber(args[1]) ])
    if args[1] then
        if not args[2] then
            SendNUIMessage({
                musicURL = musics[ tonumber(args[1]) ]
            })
        end

        if args[2] then
            SendNUIMessage({
                musicURL = musics[ tonumber(args[1]) ],
                volume = tonumber(args[2])
            })
        end

        playtime = 0
        currentMusic = musics[ tonumber(args[1]) ]
        inplay = true
    else
        --notify("<b>~r~[AVISO] ~w~Número Inválido!</b>")
        TriggerEvent("Notify", "negado", "Número Inválido!")
    end
end)

Citizen.CreateThread(function()
    while true do
        if inplay then
            playtime = playtime + 1
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand("ytbpause", function(source, args, rawCommand)
    inplay = false
    SendNUIMessage({
        musicURL = "STOP",
        volume = tonumber(args[2])
    })
end)

RegisterCommand("ytbresume", function(source, args, rawCommand)
    inplay = true
    SendNUIMessage({
        musicURL = currentMusic,
        resume = true,
        _playtime = playtime
    })
end)

function newNotify(entry, color, elements, sound)
    if (color ~= -1) then
        SetNotificationBackgroundColor(color)
    end
    SetNotificationTextEntry(entry)
    for _, element in ipairs(elements) do
            AddTextComponentSubstringPlayerName(element)
    end
    DrawNotification(false, false)
    if (sound) then
            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
    end
end

function notify(msg)
	newNotify("STRING", 11, {"" .. msg}, true)
end