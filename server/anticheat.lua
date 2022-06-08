-- CONST_POPULATION_TYPE_MISSION = 7

AddEventHandler('entityCreating', function(id)    
    local entityModel = GetEntityModel(id)
    local entityType = GetEntityType(id)

    if entityType == 3 then -- Objects
        if Shared.Anticheat.WhitelistObject then
            if Shared.Anticheat.ListObjects[entityModel] then
                CancelEvent()
            end
        end
    elseif entityType == 2 then -- Vehicles
        if Shared.Anticheat.BlacklistVehicle then
            if Shared.Anticheat.ListVehicles[entityModel] then
                CancelEvent()
            end
        end
    elseif entityType == 1 then -- Peds
        if Shared.Anticheat.BlacklistPed then
            if Shared.Anticheat.ListPeds[entityModel] then
                CancelEvent()
            end
        end
    end
end)

---BanPlayer
---@type function
---@param player table
---@param time number
---@param reason string
---@return void
---@public
Shared.Anticheat.BanPlayer = function(player, time, reason, source)
    local moderator = Offline.GetPlayerFromId(source)
    if tonumber(time) then
        if player then
            local CountHour = time
            local ids = Shared.Anticheat.ExtractIdentifiersBan(player.source)
            local ids2 = Shared.Anticheat.ExtractIdentifiersBan(moderator.source)
            local license = ids.license
            local identifier = ids.steam
            local live = ids.live
            local xbl = ids.xbl
            local discord = ids.discord
            local ip = ids.ip
            local date = {
                year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
            }

            if license == nil then
                license = 'Aucun'
            end
            if identifier == nil then
                identifier = 'Aucun'
            end
            if live == nil then
                live = 'Aucun'
            end
            if xbl == nil then
                xbl = 'Aucun'
            end
            if discord == nil then
                discord = 'Aucun'
            end
            if ip == nil then
                ip = 'Aucun'
            end

            if tonumber(CountHour) == 0 then
                MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban, permanent) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban, @permanent)', {
                    ['@token'] = GetPlayerToken(player.source),
                    ['@license'] = license, 
                    ['@identifier'] = identifier, 
                    ['@liveid'] = live, 
                    ['@xbox'] = xbl, 
                    ['@discord'] = discord, 
                    ['@ip'] = ip, 
                    ['@moderator'] = moderator.name,
                    ['@reason'] = reason,
                    ['@expiration'] = json.encode(date),
                    ['@hourban'] = 999000,
                    ['@permanent'] = 1
                })
                Wait(1000)
                MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
                    ['@license'] = license
                }, function(result)
                    table.insert(Shared.Anticheat.BanList, {
                        idban      = result[1].idban or "Aucun",
                        token      = GetPlayerToken(player.source),
                        license    = license,
                        steam      = identifier,
                        live       = live,
                        xbl        = xbl,
                        discord    = discord,
                        ip         = ip,
                        moderator  = moderator.name or "Inconnu",
                        reason     = reason,
                        expiration = json.encode(date),
                        hourban    = 999000,
                        permanent  = 1
                    })
                    DropPlayer(player.source, "Vous êtes ban de Offline\nRaison : "..reason.."\nID Bannissement : "..result[1].idban)
                end)
            else
                MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban)', {
                    ['@token'] = GetPlayerToken(player.source),
                    ['@license'] = license, 
                    ['@identifier'] = identifier,
                    ['@liveid'] = live,
                    ['@xbox'] = xbl, 
                    ['@discord'] = discord,
                    ['@ip'] = ip, 
                    ['@moderator'] = moderator.name,
                    ['@reason'] = reason,
                    ['@expiration'] = json.encode(date),
                    ['@hourban'] = CountHour
                })
                Wait(1000)
                MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
                    ['@license'] = license
                }, function(result)
                    table.insert(Shared.Anticheat.BanList, {
                        idban      = result[1].idban or "Aucun",
                        token      = GetPlayerToken(player.source),
                        license    = license,
                        steam      = identifier,
                        live       = live,
                        xbl        = xbl,
                        discord    = discord,
                        ip         = ip,
                        moderator  = moderator.name,
                        reason     = reason,
                        expiration = json.encode(date),
                        hourban    = CountHour,
                        permanent  = 0
                    })
                    DropPlayer(player.source, "Vous êtes ban de Offline\nRaison : "..reason.."\nID Bannissement : "..result[1].idban)
                end)
            end
        end
    end
end

Shared.Anticheat.BanList = {}
Shared.Anticheat.BanListActualize = {}

---ExtractIdentifiersBan
---@type function
---@param src number
---@return string
---@public
Shared.Anticheat.ExtractIdentifiersBan = function(src)
    local identifiers = {
        steam = nil,
        ip = nil,
        discord = nil,
        license = nil,
        xbl = nil,
        live = nil,
    }

    for k, v in pairs(GetPlayerIdentifiers(src)) do 
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifiers.steam = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            identifiers.license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            identifiers.xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            identifiers.ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifiers.discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            identifiers.live = v
        end
    end

    return identifiers
end

MySQL.ready(function()
    Shared.Anticheat.ReloadFromDatabase()
end)

---ReloadFromDatabase
---@type function
---@public
Shared.Anticheat.ReloadFromDatabase = function()
    MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function(result)
		if result then
		    Shared.Anticheat.BanList = {}
		    for i = 1, #result, 1 do
                table.insert(Shared.Anticheat.BanList, {
                    idban      = result[i].idban or "Aucun",
                    token      = result[i].token or "Aucun",
                    license    = result[i].license or "Aucun",
                    steam      = result[i].identifier or "Aucun",
                    live       = result[i].liveid or "Aucun",
                    xbl        = result[i].xbox or "Aucun",
                    discord    = result[i].discord or "Aucun",
                    ip         = result[i].ip or "Aucun",
                    moderator  = result[i].moderator or "Aucun",
                    reason     = result[i].reason or "Aucun",
                    expiration = result[i].expiration or "Aucun",
                    hourban    = result[i].hourban or "Aucun",
                    permanent  = result[i].permanent or "Aucun",
                })
		    end
            Config.Development.Print("Actualise Banlist")
		end
	end)
end

---AfficheBan
---@type function
---@param raison string
---@param idban number
---@param dateunban string
---@return table
---@public
Shared.Anticheat.AfficheBan = function(raison, idban, dateunban)
    card = {
        type = "AdaptiveCard",
        body = {
            {
                type = "Container",
                items = {
                    {
                        type = "TextBlock",
                        spacing = "None",
                        text = "Vous êtes banni du serveur.",
                        wrap = true
                    },
                    {
                        type = "TextBlock",
                        spacing = "None",
                        text = "Raison : "..raison,
                        wrap = true
                    },
                    {
                        type = "TextBlock",
                        spacing = "None",
                        text = "ID Bannissement : "..idban,
                        wrap = true
                    },
                    {
                        type = "TextBlock",
                        spacing = "None",
                        text = "Date unban : "..dateunban,
                        wrap = true
                    }
                }
            },
            {
                type = "Container",
                items = {
                    {
                        type = "TextBlock",
                        weight = "Bolder",
                        text = "  ",
                        wrap  = true
                    }
                }
            },
            {
                type = "ColumnSet",
                columns = {
                    {
                        type = "Column",
                        items = {
                            {
                                type = "Image",
                                url = "https://cdn.discordapp.com/attachments/943272694173016144/981703909737390080/Simpleicons_Interface_power-symbol-1.svg.png",
                                size = "Small"
                            },

                        },
                        width = "auto"
                    },
                    {
                        type = "Column",
                        items = {
                            {
                                type = "TextBlock",
                                weight = "Bolder",
                                text = "Offline",
                                wrap  = true
                            },
                            {
                                type = "TextBlock",
                                spacing = "None",
                                text = "discord.gg/offlinerp",
                                isSubtle = true,
                                wrap = true
                            }
                        },
                        width = "stretch"
                    },
                }
            },
        }, ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json", version = "1.5"
    }

    return card
end

Offline.AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local _src = source
    local playerBanned = false
    local ids = Shared.Anticheat.ExtractIdentifiersBan(_src)
    local ping = GetPlayerPing(_src)
    local token = GetPlayerToken(_src)
    local steam = ids.steam
    local ip = ids.ip
    local discord = ids.discord
    local license = ids.license
    local xbl = ids.xbl
    local live = ids.live

    deferrals.defer()

    if not license or license == '' then
        deferrals.done("Votre license rockstar est introuvable. Veuillez revenir plus tard ou signaler ce problème à l'équipe d'administration du serveur.")
        CancelEvent()
        return
    end

    if not discord or discord == '' then
        deferrals.done("Votre discord est introuvable. Veuillez revenir plus tard ou signaler ce problème à l'équipe d'administration du serveur.")
        CancelEvent()
        return
    end

    if Offline.GetPlayerFromIdentifier(license) then
        deferrals.done("Une erreur s'est produite lors du chargement de votre personnage !\nCette erreur est causée par un joueur sur le serveur qui a la même steam que vous.")
        CancelEvent()
        return
    end
        if json.encode(Shared.Anticheat.BanList) ~= "[]" then
            for k, v in pairs(Shared.Anticheat.BanList) do
                if tostring(v.token) == token or tostring(v.steam) == tostring(steam) or tostring(v.ip) == tostring(ip) or tostring(v.discord) == tostring(discord) or tostring(v.license) == tostring(license) or tostring(v.xbl) == tostring(xbl) or tostring(v.live) == tostring(live) then
                    reason = v.reason
                    moderator = v.moderator
                    idban = v.idban
                    expiration = json.decode(v.expiration)
                    hourban = v.hourban
                    permanent = v.permanent
    
                    if permanent == 1 then
                        playerBanned = true
                        return deferrals.presentCard(Shared.Anticheat.AfficheBan(reason, idban, "Permanent"))
                    elseif permanent == 0 then
                        local difftime = os.difftime(os.time(), os.time{year = expiration.year, month = expiration.month, day = expiration.day, hour = expiration.hour, min = expiration.min, sec = expiration.sec}) / 3600
    
                        if (hourban-math.floor(difftime)) <= 0 then
                            deferrals.done()
    
                            table.remove(Shared.Anticheat.BanList, k)
                            MySQL.Async.execute("DELETE FROM `banlist` WHERE `idban` = @idban", {
                                ["@idban"] = idban,
                            })
                        else
                            local endtime = os.time({year = expiration.year, month = expiration.month, day = expiration.day, hour = expiration.hour + hourban, min = expiration.min, sec = expiration.sec})
                            playerBanned = true
                            return deferrals.presentCard(Shared.Anticheat.AfficheBan(reason, idban, os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime)))
                        end
                    end
                end
            end

            if not playerBanned then
                deferrals.done()
            end
        end
end)

Offline.Commands.RegisterCommand('ban', 1, function(player, args, showError, rawCommand)
    local player = args.playerId
    local reason = ""
    sm = Offline.StringSplit(rawCommand, " ")
    for i = 4, #sm do
        reason = reason ..sm[i].. " "
    end
    Shared.Anticheat.BanPlayer(player, args.time, reason, player.source)
end, {help = "Permet de bannir un joueur", validate = false, arguments = {{name = 'playerId', help = 'Id du joueur', type = 'player'}, {name = 'time', help = "Temps du ban (en heures)", type = "number"}, {name = "reason", help = "Raison du ban", type = "fullstring"}}}, false)

Offline.Commands.RegisterCommand('banreload', 4, function(player, args, showError, rawCommand)
    Shared.Anticheat.ReloadFromDatabase()
    showError('La banlist a été rechargée')
end, {help = "Permet de recharger la liste des bans", validate = false, arguments = {}}, true)