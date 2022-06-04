---@class Offline.RegisteredZones
Offline.RegisteredZones = {}

---RegisterZone
---@type function
---@param name string
---@param coords table
---@param interactFunc function
---@param drawDist number
---@param drawMarker boolean
---@param markerInfos table
---@param drawBlip boolean
---@param blipInfos table
---@param drawNotification boolean
---@param notificationInfos table
---@param drawPed boolean
---@param pedInfos table
---@return any
---@public
Offline.RegisterZone = function(name, coords, interactFunc, drawDist, drawMarker, markerInfos, drawBlip, blipInfos, drawNotification, notificationInfos, drawPed, pedInfos)
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
            notificationInfos = notificationInfos,
            drawPed = drawPed,
            pedInfos = pedInfos
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

Offline.RegisterServerEvent('offline:haveExitedZone', function()
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    player.currentZone = "Aucune"
end)

Citizen.CreateThread(function()
    Wait(15000)
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
                end
            end
        end
    end
end)

---RegisterPeds
---@type function
---@param zones table
---@return any
---@public
Offline.RegisterPeds = function(zones)
    for name, zone in pairs(zones) do
        if zone.drawPed then
            Config.Development.Print("Registering ped " .. zone.pedInfos.pedName)
            zone.ped = Offline.SpawnPed(zone.pedInfos.pedModel, zone.pedInfos.coords)
            zone.pedNetId = NetworkGetNetworkIdFromEntity(zone.ped)
        end
    end
end