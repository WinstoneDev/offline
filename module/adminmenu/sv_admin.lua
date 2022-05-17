Offline.RegisterServerEvent('AdminServerPlayers', function()
    local _source = source

    Offline.SendEventToClient('AdminServerPlayers', _source, Offline.ServerPlayers)
end)

Offline.RegisterServerEvent('MessageAdmin', function(target, msg)
    local _source = target

    Offline.SendEventToClient('offline:notify', target, msg)
end)

Offline.RegisterServerEvent('TeleportPlayers', function(type, target)
    local _source = source

    if type == "tp" then
        SetEntityCoords(GetPlayerPed(_source), GetEntityCoords(GetPlayerPed(target)))
    elseif type == "bring" then
        SetEntityCoords(GetPlayerPed(target), GetEntityCoords(GetPlayerPed(_source)))
    end
end)