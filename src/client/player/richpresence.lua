local getNumberForFirstTime = false
_Offline_Client_.RegisterClientEvent('updateNumberPlayer', function(number)
    players = number
    getNumberForFirstTime = true
end)

Citizen.CreateThread(function()
    _Offline_Client_.SendEventToServer('updateNumberPlayer')
	while getNumberForFirstTime do
        _Offline_Client_.SendEventToServer('updateNumberPlayer')
		SetDiscordAppId(_Offline_Config_.DiscordStatus["ID"])
    	SetDiscordRichPresenceAsset(_Offline_Config_.DiscordStatus["LargeIcon"])
        SetDiscordRichPresenceAssetText(_Offline_Config_.DiscordStatus["LargeIconText"])
        SetDiscordRichPresenceAssetSmall(_Offline_Config_.DiscordStatus["SmallIcon"])
        SetDiscordRichPresenceAssetSmallText(_Offline_Config_.DiscordStatus["SmallIconText"])
        for key, value in pairs(_Offline_Config_.DiscordStatus.buttons) do
            SetDiscordRichPresenceAction(key, value.Name, value.Action)
        end
        SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. players .. "/1024")
		Wait(30000)
	end
end)