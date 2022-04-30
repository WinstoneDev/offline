Offline.RegisterClientEvent('zones:registerBlips', function(zones)
    for name, zone in pairs(zones) do
        if zone.drawBlip then
            Config.Development.Print("Registering blip " .. zone.blipInfos.blipName)
            Offline.AddBlip(zone.blipInfos.blipName, zone.blipInfos.blipSprite, zone.blipInfos.blipColor, zone.coords)
        end
    end
end)

Offline.RegisterClientEvent('zones:enteredZone', function(zone)
    Offline.PlayerData.currentZone = zone
    Offline.PlayerData.currentZone.drawedNotification = false
    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords-Offline.PlayerData.currentZone.coords)
        if dist <= Offline.PlayerData.currentZone.drawDist then
            if Offline.PlayerData.currentZone.drawMarker then
                Offline.DrawMarker(Offline.PlayerData.currentZone.markerInfos.markerType, Offline.PlayerData.currentZone.coords, Offline.PlayerData.currentZone.markerInfos.markerColor.r, Offline.PlayerData.currentZone.markerInfos.markerColor.g, Offline.PlayerData.currentZone.markerInfos.markerColor.b, Offline.PlayerData.currentZone.markerInfos.markerColor.a)
            end
            if Offline.PlayerData.currentZone.drawNotification then
                if dist <= Offline.PlayerData.currentZone.notificationInfos.drawNotificationDistance then
                    if not Offline.PlayerData.currentZone.drawedNotification then
                        TriggerEvent("WaveNotify","interact", Offline.PlayerData.currentZone.notificationInfos.notificationMessage, Offline.PlayerData.currentZone.notificationInfos.notificationName,"Interaction")
                        Offline.PlayerData.currentZone.drawedNotification = true
                    end
                    if IsControlJustPressed(0, 51) then
                        Offline.SendEventToServer('zones:haveInteract', Offline.PlayerData.currentZone.name)
                    end
                else
                    Offline.PlayerData.currentZone.drawedNotification = false
                end
            end
        else
            break
        end
        Wait(0)
    end
end)