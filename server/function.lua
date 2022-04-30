Offline = {}
Offline.RegisteredServerEvents = {}

Offline.TriggerLocalEvent = function(name, ...)
    local _source = source
    if not name then return end
    TriggerEvent(name, ...)
    Config.Development.Print("Successfully triggered event " .. name .. "from source ".. _source)
end

Offline.RegisterServerEvent = function(name, execute)
    if not name then return end
    if not Offline.RegisteredServerEvents[name] then
        RegisterNetEvent(name)
        AddEventHandler(name, function(...)
            execute(...)
        end)
        Config.Development.Print("Successfully registered event " .. name)
        Offline.RegisteredServerEvents[name] = execute
    else
        return Config.Development.Print("Event " .. name .. " already registered")
    end
end

Offline.SendEventToClient = function(name, receiver, ...)
    if not name then return end
    if not receiver then return end 

    TriggerClientEvent(name, receiver, ...)
    Config.Development.Print("Successfully sent event " .. name .. " to client ".. receiver)
end

Offline.AddEventHandler = function(name, execute)
    if not name then return end
    if not execute then return end
    AddEventHandler(name, function(...)
        execute(...)
    end)
    Config.Development.Print("Successfully added event " .. name)
end

Offline.GetEntityCoords = function(entity)
    if not entity then return end
    local _entity = GetEntityCoords(GetPlayerPed(entity))
    return vector3(_entity.x, _entity.y, _entity.z)
end

Offline.RegisterServerEvent('updateNumberPlayer', function()
    local _source = source
    Offline.SendEventToClient('updateNumberPlayer', _source, #Offline.ServerPlayers)
end)