Offline.RegisterClientEvent('zones:registerBlips', function(zones)
    for name, zone in pairs(zones) do
        if zone.drawBlip then
            Config.Development.Print("Registering blip " .. zone.blipInfos.blipName)
            Offline.AddBlip(zone.blipInfos.blipName, zone.blipInfos.blipSprite, zone.blipInfos.blipColor, zone.blipInfos.blipScale, zone.coords)
        end
    end
end)

Offline.RegisterClientEvent('zones:enteredZone', function(zone)
    if zone.drawPed then
        zone.ped = Offline.SpawnPed(zone.pedInfos.pedModel, zone.pedInfos.coords)
    end
    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(coords, zone.coords, true)
        if dist <= zone.drawDist then
            if zone.drawMarker then
                Offline.DrawMarker(zone.markerInfos.markerType, zone.coords, zone.markerInfos.markerColor.r, zone.markerInfos.markerColor.g, zone.markerInfos.markerColor.b, zone.markerInfos.markerColor.a)
            end
            if zone.drawNotification then
                if dist <= zone.notificationInfos.drawNotificationDistance and not RageUI.GetInMenu() then
                    Offline.DisplayInteract(zone.notificationInfos.notificationMessage)
                    if IsControlJustPressed(0, 51) then
                        Offline.SendEventToServer('zones:haveInteract', zone.name)
                    end
                end
            end
            if zone.drawPed then
                if dist <= zone.pedInfos.drawDistName then
                    if DoesEntityExist(zone.ped) then
                        Offline.DrawText3D(zone.pedInfos.coords.x, zone.pedInfos.coords.y, zone.pedInfos.coords.z + 1.9, zone.pedInfos.pedName, 5)
                    end
                end
            end
        else
            if DoesEntityExist(zone.ped) then
                DeleteEntity(zone.ped)
                zone.ped = nil
            end
            Offline.SendEventToServer('offline:haveExitedZone')
            RageUI.CloseAll()
            break
        end
        Wait(0)
    end
end)