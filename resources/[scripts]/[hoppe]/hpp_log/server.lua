local AvatarURL = ''

local cfg = module("hpp_log", "config/cfg")

-- MODEL -- 
--Citizen.CreateThread(function()
    --TriggerEvent("SendDiscordWebhook", "AntiCheatLog", "**Hello World** \n Tudo Bem? :)")
--end)

RegisterServerEvent("SendDiscordWebhook")
AddEventHandler("SendDiscordWebhook", function(_WebHookName, _Title, _Description)
    TriggerEvent('DiscordBot:ToDiscord', cfg.webhooks["".._WebHookName..""], "BCLRP", _Title, _Description, AvatarURL, false, false)
end)

RegisterServerEvent('DiscordBot:ToDiscord')
AddEventHandler('DiscordBot:ToDiscord', function(WebHook, Name, Title, Description, Image, External, TTS)
    local embed = {
        {
            title = Title,
            fields = Description,
            color = 1111111
        }   
    }
    print( Description )
	PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, embeds = embed, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
end)