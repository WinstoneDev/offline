local CountPlayers = nil

Offline.RegisterClientEvent('updateNumberPlayer', function(number)
    CountPlayers = number
    getNumberForFirstTime = true
end)

Citizen.CreateThread(function()
    Wait(5000)
    Offline.SendEventToServer('updateNumberPlayer')
	while true do
        local time = 0 
        if CountPlayers ~= nil then
            time = 20000
            Offline.SendEventToServer('updateNumberPlayer')
            SetDiscordAppId(Config.DiscordStatus["ID"])
            SetDiscordRichPresenceAsset(Config.DiscordStatus["LargeIcon"])
            SetDiscordRichPresenceAssetText(Config.DiscordStatus["LargeIconText"])
            SetDiscordRichPresenceAssetSmall(Config.DiscordStatus["SmallIcon"])
            SetDiscordRichPresenceAssetSmallText(Config.DiscordStatus["SmallIconText"])
            SetDiscordRichPresenceAction(0, "Discord", Config.Informations["Discord"])
            SetDiscordRichPresenceAction(1, "Se connecter", "fivem://connect/play.offlinerp.fr")
            SetRichPresence("Offline Whitelist V1\n"..GetPlayerName(PlayerId()) .. " - ".. CountPlayers .. "/1024")
        end
        Wait(time)
	end
end)