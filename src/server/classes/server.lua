---@class _Offline_Server_
---@field public RegisteredServerEvents table
---@field public TriggerLocalEvent function
---@field public RegisterServerEvent function
---@field public SendEventToClient function
---@field public AddEventHandler function
---@field public ServerPlayers table
---@field public RegisteredZones table
---@field public RegisterZone function
---@field public GetEntityCoords function$
---@public
_Offline_Server_ = {}

---@type table
---@public
_Offline_Server_.RegisteredServerEvents = {}

---TriggerLocalEvent
---@type function
---@param name string
---@public
_Offline_Server_.TriggerLocalEvent = function(name)
    local _source = source
    if not name then return end
    TriggerEvent(name)
    _Offline_Config_.Development.Print("Successfully triggered event " .. name .. "from source ".. _source)
end

---RegisterServerEvent
---@type function
---@param name string
---@param execute function
---@public
_Offline_Server_.RegisterServerEvent = function(name, execute)
    if not name then return end
    if not _Offline_Server_.RegisteredServerEvents[name] then
        RegisterNetEvent(name)
        AddEventHandler(name, function(...)
            execute(...)
        end)
        _Offline_Config_.Development.Print("Successfully registered event " .. name)
        _Offline_Server_.RegisteredServerEvents[name] = execute
    else
        return _Offline_Config_.Development.Print("Event " .. name .. " already registered")
    end
end

---SendToClientEvent
---@type function
---@param name string
---@param receiver number
---@param ... any
---@public
_Offline_Server_.SendEventToClient = function(name, receiver, ...)
    if not name then return end
    if not receiver then return end 

    if receiver == -1 then
        if _Offline_Config_.CheckIfEventIsAllowedForAllPlayers(name) then
            TriggerClientEvent(name, -1, ...)
            _Offline_Config_.Development.Print("Successfully sent event " .. name .. " to all players")
        else
            _Offline_Config_.Development.Print("Event " .. name .. " is not allowed for all players")
        end
    else
        TriggerClientEvent(name, receiver, ...)
        _Offline_Config_.Development.Print("Successfully sent event " .. name .. " to client ".. receiver)
    end
end

---AddEventhandler
---@param name string
---@param execute function
---@public
_Offline_Server_.AddEventHandler = function(name, execute)
    if not name then return end
    if not execute then return end
    AddEventHandler(name, function(...)
        execute(...)
    end)
    _Offline_Config_.Development.Print("Successfully added event " .. name)
end

---Get Entity coords from entity server side
---@type function
---@param entity number
---@return vector3
---@public
_Offline_Server_.GetEntityCoords = function(entity)
    if not entity then return end
    local _entity = GetEntityCoords(GetPlayerPed(entity))
    return vector3(_entity.x, _entity.y, _entity.z)
end

_Offline_Server_.RegisterServerEvent('updateNumberPlayer', function()
    local _source = source
    Wait(1000)
    _Offline_Server_.SendEventToClient('updateNumberPlayer', _source, #_Offline_Server_.ServerPlayers)
end)