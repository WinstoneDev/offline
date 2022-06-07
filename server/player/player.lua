---@class Offline.ServerPlayers
Offline.ServerPlayers = {}

local function GetPlayerDiscord(source)
    local _source = source
    local discord = nil
    for _, v in pairs(GetPlayerIdentifiers(_source)) do
        if string.find(v, "discord:") then
            discord = v
        end
    end  
    if not discord then
        discord = "Aucun discord"
    end
    return discord
end

local function GetPlayerIndentifier(source)
    local _source = source
    local identifier = nil
    for _, v in pairs(GetPlayerIdentifiers(_source)) do
        if string.find(v, "license:") then
            identifier = v
        end
    end  
    if not identifier then
        identifier = "Aucune license"
    end
    return identifier
end

RegisterNetEvent("registerPlayer")
AddEventHandler("registerPlayer", function()
    local source = source

    if not Offline.ServerPlayers[source] then
        Offline.GeneratorTokenConnecting(source)
        MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIndentifier(source)
        }, function(result)
            if not result[1] then
                Offline.ServerPlayers[source] = {
                    name = GetPlayerName(source),
                    identifier = GetPlayerIndentifier(source),
                    ip = GetPlayerEP(source),
                    discordId = GetPlayerDiscord(source),
                    source = source,
                    token = GetPlayerToken(source),
                    characterInfos = {Sexe = "Aucun", LDN = "Aucun", Prenom = "Aucun", NDF = "Aucun", Taille = 180, DDN = "19/04/1999"},
                    inventory = {},
                    currentZone = "Aucune",
                    coords = vector3(0, 0, 0),
                    weight = Offline.Inventory.GetInventoryWeight({}) or 0,
                    healt = 200,
                    skin = nil,
                    cash = Config.Informations["StartMoney"].cash,
                    dirty = Config.Informations["StartMoney"].dirty,
                    group = Config.StaffGroups[0]
                }
                MySQL.Async.insert('INSERT INTO players (identifier, discordId, token, characterInfos, coords) VALUES(@identifier, @discordId, @token, @characterInfos, @coords)', {
                    ['@identifier'] = Offline.ServerPlayers[source].identifier,
                    ['@discordId'] = Offline.ServerPlayers[source].discordId,
                    ['@token'] = Offline.ServerPlayers[source].token,
                    ['@characterInfos'] = json.encode(Offline.ServerPlayers[source].characterInfos),
                    ['@coords'] = json.encode(Offline.ServerPlayers[source].coords)
                }, function()
                end)
                Wait(500)
                MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
                    ['@identifier'] = Offline.ServerPlayers[source].identifier
                }, function(result)
                    if result[1] then
                        Offline.ServerPlayers[source].id = result[1].id
                    end
                end)
                Offline.SendEventToClient('InitPlayer', source, Offline.ServerPlayers[source])
                Wait(15000)
                for k,v in pairs(GetAllPeds()) do
                    if DoesEntityExist(v) then
                        DeleteEntity(v)
                    end
                end
                Offline.RegisterPeds(Offline.RegisteredZones)
                Config.Development.Print("Successfully registered player " .. GetPlayerName(source))
                Offline.SendEventToClient('zones:registerBlips', source, Offline.RegisteredZones)
            else
                Offline.ServerPlayers[source] = {
                    id = result[1].id,
                    name = GetPlayerName(source),
                    identifier = result[1].identifier,
                    ip = GetPlayerEP(source),
                    discordId = GetPlayerDiscord(source),
                    source = source,
                    token = GetPlayerToken(source),
                    characterInfos = json.decode(result[1].characterInfos),
                    inventory = json.decode(result[1].inventory),
                    currentZone = "Aucune",
                    coords = json.decode(result[1].coords),
                    weight = 0,
                    health = result[1].health,
                    skin = json.decode(result[1].skin),
                    cash = json.decode(result[1].money).cash,
                    dirty = json.decode(result[1].money).dirty,
                    group = result[1].group
                }
                MySQL.Async.execute('UPDATE players SET token = @token, discordId = @discordId WHERE identifier = @identifier', {
                    ['@token'] = Offline.ServerPlayers[source].token,
                    ['@discordId'] = Offline.ServerPlayers[source].discordId,
                    ['@identifier'] = Offline.ServerPlayers[source].identifier
                })
                Wait(250)
                local weight = Offline.Inventory.GetInventoryWeight(Offline.ServerPlayers[source].inventory)
                Offline.ServerPlayers[source].weight = weight or 0
                Wait(250)
                Offline.SendEventToClient('InitPlayer', source, Offline.ServerPlayers[source])
                Wait(10000)
                for k,v in pairs(GetAllPeds()) do
                    if DoesEntityExist(v) then
                        DeleteEntity(v)
                    end
                end
                Offline.RegisterPeds(Offline.RegisteredZones)
                Config.Development.Print("Successfully registered player " .. GetPlayerName(source))
                Offline.SendEventToClient('zones:registerBlips', source, Offline.RegisteredZones)
            end
        end)
    else
        Config.Development.Print("Player " .. source .. " already registered")
        DropPlayer(source, "Player " .. source .. " already registered ╭∩╮（︶_︶）╭∩╮")
    end
end)

CreateThread(function()
    while true do
        for k, player in pairs(Offline.ServerPlayers) do
            local coords = Offline.GetEntityCoords(player.source)
            if player.coords ~= coords then
                player.coords = coords
                Offline.SendEventToClient('UpdatePlayer', player.source, Offline.ServerPlayers[player.source])
            end
        end
        Wait(5000)
    end
end)

Offline.AddEventHandler('playerDropped', function()
    local _source = source
    if Offline.ServerPlayers[_source] then
        MySQL.Async.execute('UPDATE players SET coords = @coords, inventory = @inventory, money = @money, health = @health WHERE id = @id', {
            ['@coords'] = json.encode(Offline.ServerPlayers[_source].coords),
            ['@inventory'] = json.encode(Offline.ServerPlayers[_source].inventory),
            ['@money'] = json.encode({cash = Offline.ServerPlayers[_source].cash, dirty = Offline.ServerPlayers[_source].dirty}),
            ['@id'] = Offline.ServerPlayers[_source].id,
            ['@health'] = GetEntityHealth(GetPlayerPed(source))
        })
        Offline.ServerPlayers[_source] = nil
        Config.Development.Print("Player " .. _source .. " disconnected")
    end
end)

RegisterCommand('sync', function(source)
    MySQL.Async.execute('UPDATE players SET coords = @coords, inventory = @inventory, money = @money, health = @health WHERE id = @id', {
        ['@coords'] = json.encode(Offline.ServerPlayers[source].coords),
        ['@inventory'] = json.encode(Offline.ServerPlayers[source].inventory),
        ['@money'] = json.encode({cash = Offline.ServerPlayers[source].cash, dirty = Offline.ServerPlayers[source].dirty}),
        ['@id'] = Offline.ServerPlayers[source].id,
        ['@health'] = GetEntityHealth(GetPlayerPed(source))
    })
end, false)

-- --- Function that print elapsed months, days, hours since a date
-- function Offline.GetTimeElapsed(date)
--     local now = os.time()
--     local diff = now - date
--     local seconds = diff % 60
--     local minutes = math.floor(diff / 60) % 60
--     local hours = math.floor(diff / 3600) % 24
--     local days = math.floor(diff / 86400) % 30
--     local months = math.floor(diff / 2592000) % 12
--     local years = math.floor(diff / 31536000)
--     return months .. " mois, "..days.." jours, " .. hours .. " heures, " .. minutes .. " minutes et " .. seconds .. " secondes"
-- end


-- CreateThread(function()
--     while true do
--         print(Offline.GetTimeElapsed(os.time{year=2022, month=3, day=6, hour=21, min = 0, sec = 0}))
--         Wait(1000)
--     end
-- end)