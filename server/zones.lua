Offline.RegisteredZones = {}

Offline.RegisterZone = function(name, coords, interactFunc, drawDist, drawMarker, markerInfos, drawBlip, blipInfos, drawNotification, notificationInfos)
    if not name then return end
    if not coords then return end
    if not interactFunc then return end
    if not drawDist then return end
    if not Offline.RegisteredZones[name] then
        Offline.RegisteredZones[name] = {
            name = name,
            coords = coords,
            interactFunc = interactFunc,
            drawDist = drawDist,
            drawMarker = drawMarker,
            markerInfos = markerInfos,
            drawBlip = drawBlip,
            blipInfos = blipInfos,
            drawNotification = drawNotification,
            notificationInfos = notificationInfos
        }
        Config.Development.Print("Successfully registered zone " .. name)
    else
        return Config.Development.Print("Zone " .. name .. " already registered")
    end
end

Offline.RegisterServerEvent('zones:haveInteract', function(zone)
    local _source = source
    CreateThread(function()
        if Offline.RegisteredZones[zone].interactFunc then
            Offline.RegisteredZones[zone].interactFunc(_source)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for index, player in pairs(Offline.ServerPlayers) do
            local _coords = Offline.GetEntityCoords(player.source)
              for name, zone in pairs(Offline.RegisteredZones) do
                if #(_coords-zone.coords) <= zone.drawDist then
                    if player.currentZone ~= name then
                        Config.Development.Print('Player '..player.source..' is in zone ' .. name)
                        Offline.SendEventToClient('zones:enteredZone', player.source, zone)
                        player.currentZone = name
                    end
                else
                    player.currentZone = "Aucune"
                end
            end
        end
    end
end)