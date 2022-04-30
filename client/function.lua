Offline = {}
Offline.RegisteredClientEvents = {}

Offline.TriggerLocalEvent = function(name, ...)
    if not name then return end
    TriggerEvent(name, ...)
    Config.Development.Print("Successfully triggered event " .. name)
end

Offline.RegisterClientEvent = function(name, execute)
    if not name then return end
    if not Offline.RegisteredClientEvents[name] then
        RegisterNetEvent(name)
        AddEventHandler(name, function(...)
            execute(...)
        end)
        Config.Development.Print("Successfully registered event " .. name)
        Offline.RegisteredClientEvents[name] = execute
    else
        return Offline.Development.Print("Event " .. name .. " already registered")
    end
end

Offline.RegisterClientEvent('getSharedObject', function(cb)
    cb(Offline)
end)

Offline.AddEventHandler = function(name, execute)
    if not name then return end
    if not execute then return end
    AddEventHandler(name, function(...)
        execute(...)
    end)
    Config.Development.Print("Successfully added event " .. name)
end

Offline.SendEventToServer = function(name, ...)
    if not name then return end
    TriggerServerEvent(name, ...)
    Config.Development.Print("Successfully triggered server event " .. name)
end

Offline.KeyboardInput = function(textEntry, maxLength)
    AddTextEntry("Message", textEntry)
    DisplayOnscreenKeyboard(1, "Message", '', '', '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

Offline.DrawText3D = function(x, y, z, text, distance, v3)
    local dist = distance or 7
    local aze, zea, aez = table.unpack(GetGameplayCamCoords())
    local plyCoords = GetEntityCoords(PlayerPedId())
    distance = GetDistanceBetweenCoords(aze, zea, aez, x, y, z, 1)
    local Text3D = GetDistanceBetweenCoords((plyCoords), x, y, z, 1) - 1.65
    local scale, fov = ((1 / distance) * (dist * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if Text3D < dist then
        fov = math.floor(255 * ((dist - Text3D) / dist))
    elseif Text3D >= dist then
        fov = 0
    end
    fov = v3 or fov
    SetTextFont(0)
    SetTextScale(.0 * scale, .1 * scale)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, fov)))
    SetTextCentre(1)
    SetDrawOrigin(x, y, z, 0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Offline.AddBlip = function(blipName, blipSprite, blipColor, coords)
    if not blipName then return end
    if not blipSprite then return end
    if not blipColor then return end
    if not coords then return end
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipSprite)
    SetBlipColour(blip, blipColor)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipName)
    EndTextCommandSetBlipName(blip)
end

Offline.DrawMarker = function(markerType, coords, r, g, b, a)
    if not markerType then return end
    if not coords then return end
    if not r then return end
    if not g then return end
    if not b then return end
    if not a then return end
    DrawMarker(markerType, coords.x, coords.y, coords.z-0.98, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, r, g, b, a, false, false, false, false)
end

Offline.SetCoords = function(coords)
    if not coords then return end
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
end

Offline.ShowNotification = function(message)
    if not message then return end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

Offline.GetClosestPlayer = function(player, distance)
    if not player then return end
    if not distance then return end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = nil, distance or -1
    for _, player in ipairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)
        if target ~= playerPed then
            local targetCoords = GetEntityCoords(target)
            local distance = #(playerCoords - targetCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = target
                closestDistance = distance
            end
        end
    end
    return closestPlayer
end

Offline.RequestAnimDict = function(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

Offline.RegisterClientEvent('offline:notify', function(message)
    Offline.ShowNotification(message)
end)