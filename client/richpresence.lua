local CountPlayers = nil

Offline.RegisterClientEvent('offline:receiveNumberPlayers', function(number)
    CountPlayers = number
end)

Citizen.CreateThread(function()
    Wait(5000)
    Offline.SendEventToServer('offline:updateNumberPlayer')
    Wait(500)
	while true do
        local time = 20000
        if CountPlayers ~= nil then
            Offline.SendEventToServer('offline:updateNumberPlayer')
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