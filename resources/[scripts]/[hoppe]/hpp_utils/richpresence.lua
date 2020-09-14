Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
        SetDiscordAppId(551881132510281737)
        SetRichPresence("discord.gg/6AwZmUg")

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('large')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('discord.gg/6AwZmUg')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('large')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('discord.gg/6AwZmUg')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)