---@type table
---@public
_Offline_Server_.RegisteredZones = {}

---RegisterZone
---@type function
---@param name string
---@param coords vector3
---@param interactFunc function
---@param drawDist number
---@param drawMarker boolean
---@param markerInfos table
---@param drawBlip boolean
---@param blipInfos table
---@param drawNotification boolean
---@param notificationInfos table
---@public
_Offline_Server_.RegisterZone = function(name, coords, interactFunc, drawDist, drawMarker, markerInfos, drawBlip, blipInfos, drawNotification, notificationInfos)
    if not name then return end
    if not coords then return end
    if not interactFunc then return end
    if not drawDist then return end
    if not _Offline_Server_.RegisteredZones[name] then
        _Offline_Server_.RegisteredZones[name] = {
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
        _Offline_Config_.Development.Print("Successfully registered zone " .. name)
    else
        return _Offline_Config_.Development.Print("Zone " .. name .. " already registered")
    end
end

_Offline_Server_.RegisterServerEvent('zones:haveInteract', function(zone)
    local _source = source
    CreateThread(function()
        if _Offline_Server_.RegisteredZones[zone].interactFunc then
            _Offline_Server_.RegisteredZones[zone].interactFunc(_source)
        end
    end)
end)

---Zone_Handler
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for index, player in pairs(_Offline_Server_.ServerPlayers) do
            ---@type _Coords_
            local _coords = _Offline_Server_.GetEntityCoords(player.source)
              for name, zone in pairs(_Offline_Server_.RegisteredZones) do
                if #(_coords-zone.coords) <= zone.drawDist then
                    if player.currentZone ~= name then
                        _Offline_Config_.Development.Print('Player '..player.source..' is in zone ' .. name)
                        ---@type _Send_Server_Event_
                        _Offline_Server_.SendEventToClient('zones:enteredZone', player.source, zone)
                        player.currentZone = name
                    end
                else
                    player.currentZone = "Aucune"
                end
            end
        end
    end
end)