_Offline_Client_.RegisterClientEvent('zones:registerBlips', function(zones)
    for name, zone in pairs(zones) do
        if zone.drawBlip then
            _Offline_Config_.Development.Print("Registering blip " .. zone.blipInfos.blipName)
            _Offline_Client_.AddBlip(zone.blipInfos.blipName, zone.blipInfos.blipSprite, zone.blipInfos.blipColor, zone.coords)
        end
    end
end)

_Offline_Client_.RegisterClientEvent('zones:enteredZone', function(zone)
    _Offline_Player.currentZone = zone
    _Offline_Player.currentZone.drawedNotification = false
    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords-_Offline_Player.currentZone.coords)
        if dist <= _Offline_Player.currentZone.drawDist then
            if _Offline_Player.currentZone.drawMarker then
                _Offline_Client_.DrawMarker(_Offline_Player.currentZone.markerInfos.markerType, _Offline_Player.currentZone.coords, _Offline_Player.currentZone.markerInfos.markerColor.r, _Offline_Player.currentZone.markerInfos.markerColor.g, _Offline_Player.currentZone.markerInfos.markerColor.b, _Offline_Player.currentZone.markerInfos.markerColor.a)
            end
            if _Offline_Player.currentZone.drawNotification then
                if dist <= _Offline_Player.currentZone.notificationInfos.drawNotificationDistance then
                    if not _Offline_Player.currentZone.drawedNotification then
                        TriggerEvent("WaveNotify","interact", _Offline_Player.currentZone.notificationInfos.notificationMessage, _Offline_Player.currentZone.notificationInfos.notificationName,"Interaction")
                        _Offline_Player.currentZone.drawedNotification = true
                    end
                    if IsControlJustPressed(0, 51) then
                        _Offline_Client_.SendEventToServer('zones:haveInteract', _Offline_Player.currentZone.name)
                    end
                else
                    _Offline_Player.currentZone.drawedNotification = false
                end
            end
        else
            break
        end
        Wait(0)
    end
end)