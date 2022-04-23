local players = 0
_Offline_Client_.RegisterClientEvent('updateNumberPlayer', function(number)
    players = number
end)

Citizen.CreateThread(function()
	while true do
        _Offline_Client_.SendEventToServer('updateNumberPlayer')
		SetDiscordAppId(_Offline_Config_.DiscordStatus["ID"])
    	SetDiscordRichPresenceAsset(_Offline_Config_.DiscordStatus["LargeIcon"])
        SetDiscordRichPresenceAssetText(_Offline_Config_.DiscordStatus["LargeIconText"])
        SetDiscordRichPresenceAssetSmall(_Offline_Config_.DiscordStatus["SmallIcon"])
        SetDiscordRichPresenceAssetSmallText(_Offline_Config_.DiscordStatus["SmallIconText"])
        for key, value in pairs(_Offline_Config_.DiscordStatus.buttons) do
            SetDiscordRichPresenceAssetButton(key, value.Name, value.Action)
        end
        SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. players .. "/1024")
		Wait(30000)
	end
end)