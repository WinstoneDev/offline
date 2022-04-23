---@type table
---@public
_Offline_Server_.ServerPlayers = {}

---GetPlayerDiscord
---@type function
---@param source string
---@return string
---@private
local function GetPlayerDiscord(source)
    local _source = source
    local discord = nil
    for _, v in pairs(GetPlayerIdentifiers(_source)) do
        if string.find(v, "discord:") then
            discord = v
        end
    end  
    if not discord then return "Aucun discord" end
    return discord
end

---GetPlayerIndentifier
---@type function
---@param source string
---@return string
---@private
local function GetPlayerIndentifier(source)
    local _source = source
    local Identifier = nil
    for _, v in pairs(GetPlayerIdentifiers(_source)) do
        if string.find(v, "license:") then
            Identifier = v
        end
    end  
    if not Identifier then return "Aucune license" end
    return Identifier
end

---@type _Server_Event_
_Offline_Server_.RegisterServerEvent('registerPlayer', function(source)
    if not source then return end
    if not _Offline_Server_.ServerPlayers[source] then
        MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIndentifier(source)
        }, function(result)
            if not result[1] then
                _Offline_Server_.ServerPlayers[source] = {
                    name = GetPlayerName(source),
                    identifier = GetPlayerIndentifier(source),
                    ip = GetPlayerEP(source),
                    discordId = GetPlayerDiscord(source),
                    source = source,
                    token = GetPlayerToken(source),
                    characterInfos = {},
                    inventory = {},
                    currentZone = "Aucune",
                    coords = vector3(0,0,0),
                    weight = _Offline_Inventory_.GetInventoryWeight({}) or 0
                }
                MySQL.Async.execute('INSERT INTO players (identifier, discordId, token, characterInfos, coords) VALUES(@identifier, @discordId, @token, @characterInfos, @coords)', {
                    ['@identifier'] = _Offline_Server_.ServerPlayers[source].identifier,
                    ['@discordId'] = _Offline_Server_.ServerPlayers[source].discordId,
                    ['@token'] = _Offline_Server_.ServerPlayers[source].token,
                    ['@characterInfos'] = json.encode(_Offline_Server_.ServerPlayers[source].characterInfos),
                    ['@coords'] = json.encode(_Offline_Server_.ServerPlayers[source].coords)
                }, function(result)
                    MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
                        ['@identifier'] = _Offline_Server_.ServerPlayers[source].identifier
                    }, function(result)
                        _Offline_Server_.ServerPlayers[source].id = result[1].id
                    end)
                    _Offline_Server_.SendEventToClient('InitPlayer', source, _Offline_Server_.ServerPlayers[source])
                    _Offline_Config_.Development.Print("Successfully registered player " .. GetPlayerName(source))
                end)
            else
                _Offline_Server_.ServerPlayers[source] = {
                    id = result[1].id,
                    name = GetPlayerName(source),
                    identifier = result[1].identifier,
                    ip = GetPlayerEP(source),
                    discordId = GetPlayerDiscord(source),
                    source = source,
                    token = GetPlayerToken(source),
                    characterInfos = {},
                    inventory = {},
                    currentZone = "Aucune",
                    coords = json.decode(result[1].coords),
                    weight = 0
                }
                MySQL.Async.execute('UPDATE players SET token = @token, discordId = @discordId WHERE identifier = @identifier', {
                    ['@token'] = _Offline_Server_.ServerPlayers[source].token,
                    ['@discordId'] = _Offline_Server_.ServerPlayers[source].discordId,
                    ['@identifier'] = _Offline_Server_.ServerPlayers[source].identifier
                })
                _Offline_Inventory_.LoadInventoryFromDatabase(_Offline_Server_.ServerPlayers[source], function(inventory)
                    _Offline_Server_.ServerPlayers[source].inventory = json.decode(inventory)
                end)                
                Wait(250)
                local weight = _Offline_Inventory_.GetInventoryWeight(_Offline_Server_.ServerPlayers[source].inventory)
                _Offline_Server_.ServerPlayers[source].weight = weight or 0
                Wait(250)
                _Offline_Server_.SendEventToClient('InitPlayer', source, _Offline_Server_.ServerPlayers[source])
                _Offline_Config_.Development.Print("Successfully registered player " .. GetPlayerName(source))
            end
        end)
        _Offline_Server_.SendEventToClient('zones:registerBlips', source, _Offline_Server_.RegisteredZones)
    else
        _Offline_Config_.Development.Print("Player " .. source .. " already registered")
    end
end)

CreateThread(function()
    while true do
        for k, player in pairs(_Offline_Server_.ServerPlayers) do
            local coords = _Offline_Server_.GetEntityCoords(player.source)
            if player.coords ~= coords then
                player.coords = coords
                _Offline_Server_.SendEventToClient('UpdatePlayer', player.source, _Offline_Server_.ServerPlayers[player.source])
            end
        end
        Wait(10000)
    end
end)

_Offline_Server_.AddEventHandler('playerDropped', function()
    local _source = source
    if _Offline_Server_.ServerPlayers[_source] then
        MySQL.Async.execute('UPDATE players SET coords = @coords WHERE id = @id', {
            ['@coords'] = json.encode(_Offline_Server_.ServerPlayers[_source].coords),
            ['@id'] = _Offline_Server_.ServerPlayers[_source].id
        })
        _Offline_Inventory_.SaveInventoryInDatabase(_Offline_Server_.ServerPlayers[_source], _Offline_Server_.ServerPlayers[_source].inventory)
        _Offline_Server_.ServerPlayers[_source] = nil
        _Offline_Config_.Development.Print("Player " .. _source .. " disconnected")
    end
end)

RegisterCommand('sync', function(source)
    MySQL.Async.execute('UPDATE players SET coords = @coords WHERE id = @id', {
        ['@coords'] = json.encode(_Offline_Server_.ServerPlayers[source].coords),
        ['@id'] = _Offline_Server_.ServerPlayers[source].id
    })
    _Offline_Inventory_.SaveInventoryInDatabase(_Offline_Server_.ServerPlayers[source], _Offline_Server_.ServerPlayers[source].inventory)
end, false)