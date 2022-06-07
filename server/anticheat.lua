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

-- ---BanPlayer
-- ---@type function
-- ---@return void
-- ---@public
-- Shared.Anticheat:BanPlayer = function()

-- end

-- local BanList = {}
-- local BanListActualize = {}

-- function SendWebhookBan(title, message, webhook, color)
-- 	local content = {
--         {
--         	["color"] = color,
--             ["title"] = title,
--             ["description"] = message,
--             ["footer"] = {["text"] = os.date("%Y/%m/%d %H:%M:%S")}, 
--         }
--     }

--   	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
-- end

-- ExtractIdentifiersBan = function(src)
--     local identifiers = {
--         steam = nil,
--         ip = nil,
--         discord = nil,
--         license = nil,
--         xbl = nil,
--         live = nil,
--     }

--     for k, v in pairs(GetPlayerIdentifiers(src)) do 
--         if string.sub(v, 1, string.len("steam:")) == "steam:" then
--             identifiers.steam = v
--         elseif string.sub(v, 1, string.len("license:")) == "license:" then
--             identifiers.license = v
--         elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
--             identifiers.xbl  = v
--         elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
--             identifiers.ip = v
--         elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
--             identifiers.discord = v
--         elseif string.sub(v, 1, string.len("live:")) == "live:" then
--             identifiers.live = v
--         end
--     end

--     return identifiers
-- end

-- MySQL.ready(function()
--     MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function(result)
-- 		if result then
-- 		    BanList = {}
-- 		    for i = 1, #result, 1 do
--                 table.insert(BanList, {
--                     idban      = result[i].idban or "Aucun",
--                     token      = result[i].token or "Aucun",
--                     license    = result[i].license or "Aucun",
--                     steam      = result[i].identifier or "Aucun",
--                     live       = result[i].liveid or "Aucun",
--                     xbl        = result[i].xbox or "Aucun",
--                     discord    = result[i].discord or "Aucun",
--                     ip         = result[i].ip or "Aucun",
--                     moderator  = result[i].moderator or "Aucun",
--                     reason     = result[i].reason or "Aucun",
--                     expiration = result[i].expiration or "Aucun",
--                     hourban    = result[i].hourban or "Aucun",
--                     permanent  = result[i].permanent or "Aucun",
--                 })
-- 		    end
--             print("Actualise Banlist")
-- 		end
-- 	end)
-- end)

-- RegisterNetEvent('esx:playerLoaded')
-- AddEventHandler('esx:playerLoaded', function(source, xPlayer)
--     local _src = source
--     local xPlayer = ESX.GetPlayerFromId(_src)
--     local ids = ExtractIdentifiersBan(_src)
--     local token = GetPlayerToken(_src)
--     local table = {token = token, live = ids.live, xbl = ids.xbl, discord = ids.discord, ip = ids.ip}

--     MySQL.Async.execute("UPDATE users SET infoban = @infoban WHERE identifier = @identifier", {
--         ['@identifier'] = xPlayer.identifier,
--         ['@infoban'] = json.encode(table)
--     })
-- end)

-- function AfficheBan(raison, idban, dateunban)
--     card = {
--         type = "AdaptiveCard",
--         body = {
--             {
--                 type = "Container",
--                 items = {
--                     {
--                         type = "TextBlock",
--                         spacing = "None",
--                         text = "Vous êtes banni du serveur.",
--                         wrap = true
--                     },
--                     {
--                         type = "TextBlock",
--                         spacing = "None",
--                         text = "Raison : "..raison,
--                         wrap = true
--                     },
--                     {
--                         type = "TextBlock",
--                         spacing = "None",
--                         text = "ID Bannissement : "..idban,
--                         wrap = true
--                     },
--                     {
--                         type = "TextBlock",
--                         spacing = "None",
--                         text = "Date unban : "..dateunban,
--                         wrap = true
--                     }
--                 }
--             },
--             {
--                 type = "Container",
--                 items = {
--                     {
--                         type = "TextBlock",
--                         weight = "Bolder",
--                         text = "  ",
--                         wrap  = true
--                     }
--                 }
--             },
--             {
--                 type = "ColumnSet",
--                 columns = {
--                     {
--                         type = "Column",
--                         items = {
--                             {
--                                 type = "Image",
--                                 url = "https://cdn.discordapp.com/attachments/943272694173016144/981703909737390080/Simpleicons_Interface_power-symbol-1.svg.png",
--                                 size = "Small"
--                             },

--                         },
--                         width = "auto"
--                     },
--                     {
--                         type = "Column",
--                         items = {
--                             {
--                                 type = "TextBlock",
--                                 weight = "Bolder",
--                                 text = "Offline",
--                                 wrap  = true
--                             },
--                             {
--                                 type = "TextBlock",
--                                 spacing = "None",
--                                 text = "discord.gg/offlinerp",
--                                 isSubtle = true,
--                                 wrap = true
--                             }
--                         },
--                         width = "stretch"
--                     },
--                 }
--             },
--         }, ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json", version = "1.5"
--     }

--     return card
-- end

-- AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
--     local _src = source
--     local playerBanned = false
--     local ids = ExtractIdentifiersBan(_src)
--     local ping = GetPlayerPing(_src)
--     local token = GetPlayerToken(_src)
--     local steam = ids.steam
--     local ip = ids.ip
--     local discord = ids.discord
--     local license = ids.license
--     local xbl = ids.xbl
--     local live = ids.live

--     deferrals.defer()

--     if not steam or steam == '' then
--         deferrals.done("Votre steam est introuvable. Veuillez revenir plus tard ou signaler ce problème à l'équipe d'administration du serveur.")
--         CancelEvent()
--         return
--     end

--     if not license or license == '' then
--         deferrals.done("Votre license rockstar est introuvable. Veuillez revenir plus tard ou signaler ce problème à l'équipe d'administration du serveur.")
--         CancelEvent()
--         return
--     end

--     if not discord or discord == '' then
--         deferrals.done("Votre discord est introuvable. Veuillez revenir plus tard ou signaler ce problème à l'équipe d'administration du serveur.")
--         CancelEvent()
--         return
--     end

--     if ESX.GetPlayerFromIdentifier(steam) then
--         deferrals.done("Une erreur s'est produite lors du chargement de votre personnage !\nCette erreur est causée par un joueur sur le serveur qui a le même identifiant steam que vous.")
--         CancelEvent()
--         return
--     end

--     --exports.extendedmode:getGuildMemberForPlayer("930595342683078717", _src, "OTQ3MjI3Nzk0NjcxMzAwNjE4.GdeAmE.tetrhqm6sMe3uPYrlYxZ8VD-EpqZcrz6B6qka4"):next(function(member)
--         if json.encode(BanList) ~= "[]" then
--             for k, v in pairs(BanList) do
--                 if tostring(v.token) == token or tostring(v.steam) == tostring(steam) or tostring(v.ip) == tostring(ip) or tostring(v.discord) == tostring(discord) or tostring(v.license) == tostring(license) or tostring(v.xbl) == tostring(xbl) or tostring(v.live) == tostring(live) then
--                     reason = v.reason
--                     moderator = v.moderator
--                     idban = v.idban
--                     expiration = json.decode(v.expiration)
--                     hourban = v.hourban
--                     permanent = v.permanent
    
--                     if permanent == 1 then
--                         playerBanned = true
--                         SendWebhookBan("Connexion arrêtée par le bannissement", "**Discord ID :** <@"..ids.discord:gsub("discord:", "")..">\n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""), 16).."\n**Date unban :** Permanent", "https://discord.com/api/webhooks/958881541700857886/9xLGnWC3PIdXyxLuF-szwurStYrBgh6gqt0lHPQ2V2CsrYLVZ_MnGrV9iaLAKEITMSnN", '3863105')
--                         return deferrals.presentCard(AfficheBan(reason, idban, "Permanent"))
--                     elseif permanent == 0 then
--                         local difftime = os.difftime(os.time(), os.time{year = expiration.year, month = expiration.month, day = expiration.day, hour = expiration.hour, min = expiration.min, sec = expiration.sec}) / 3600
    
--                         if (hourban-math.floor(difftime)) <= 0 then
--                             deferrals.done()
    
--                             table.remove(BanList, k)
--                             MySQL.Async.execute("DELETE FROM `banlist` WHERE `idban` = @idban", {
--                                 ["@idban"] = idban,
--                             })
--                         else
--                             local endtime = os.time({year = expiration.year, month = expiration.month, day = expiration.day, hour = expiration.hour + hourban, min = expiration.min, sec = expiration.sec})
--                             playerBanned = true
--                             SendWebhookBan("Connexion arrêtée par le bannissement", "**Discord ID :** <@"..ids.discord:gsub("discord:", "")..">\n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""), 16).."\n**Date unban :** "..os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime), "https://discord.com/api/webhooks/958881541700857886/9xLGnWC3PIdXyxLuF-szwurStYrBgh6gqt0lHPQ2V2CsrYLVZ_MnGrV9iaLAKEITMSnN", '3863105')
--                             return deferrals.presentCard(AfficheBan(reason, idban, os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime)))
--                         end
--                     end
--                 end
--             end

--             if not playerBanned then
--                 deferrals.done()
--             end
--         end
--     -- end, function(err)
--     --     if err == 404 then
--     --         deferrals.done("Vous devez rejoindre le discord - discord.gg/offlinerp")
--     --     else
--     --         deferrals.done("Impossible de vérifier le statut du discord : "..err)
--     --     end
--     -- end)
-- end)

-- AddEventHandler("playerDropped", function(reason)
--     local _src = source
--     local ids = ExtractIdentifiersBan(_src)
--     local ping = GetPlayerPing(_src)
--     local identifier = GetPlayerIdentifiers(_src)[1]

--     if _src ~= nil and ids ~= nil and ping ~= nil then
--         SendWebhookBan("Deconnexion", "**ID in game :** ".._src.."\n**License :** license:"..ids.license:gsub("license2:", "").."\n**Discord ID :** <@"..ids.discord:gsub("discord:", "")..">\n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""), 16).."\n**Ping :** "..ping, "https://discord.com/api/webhooks/958881238377173053/fF4KnV_9fun5bYbvi0c-7h-MmLPV77yhfupUsm2TyihrkmvMIgOWjOP-0y0HhRx27LSr", '3863105')
--     end
-- end)

-- function stringsplit(inputstr, sep)
--     if sep == nil then
--         sep = "%s"
--     end
--     local t = {} ; i = 1
--     for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--         t[i] = str
--         i = i + 1
--     end
--     return t
-- end

-- RegisterCommand("ban", function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
--         if tonumber(args[1]) and tonumber(args[2]) then
--             local xTarget = ESX.GetPlayerFromId(args[1])
--             if xTarget then
--                 local _src = args[1]
--                 local CountHour = args[2]
--                 local ids = ExtractIdentifiersBan(_src)
--                 local ids2 = ExtractIdentifiersBan(source)
--                 local license = ids.license
--                 local identifier = ids.steam
--                 local live = ids.live
--                 local xbl = ids.xbl
--                 local discord = ids.discord
--                 local ip = ids.ip
--                 local date = {
--                     year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
--                 }

--                 if license == nil then
--                     license = 'Aucun'
--                 end
--                 if identifier == nil then
--                     identifier = 'Aucun'
--                 end
--                 if live == nil then
--                     live = 'Aucun'
--                 end
--                 if xbl == nil then
--                     xbl = 'Aucun'
--                 end
--                 if discord == nil then
--                     discord = 'Aucun'
--                 end
--                 if ip == nil then
--                     ip = 'Aucun'
--                 end

--                 sm = stringsplit(rawCommand, " ")
--                 message = ""
--                 for i = 4, #sm do
--                     message = message ..sm[i].. " "
--                 end

--                 if tonumber(CountHour) == 0 then
--                     MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban, permanent) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban, @permanent)', {
--                         ['@token'] = GetPlayerToken(_src),
--                         ['@license'] = license, 
--                         ['@identifier'] = identifier, 
--                         ['@liveid'] = live, 
--                         ['@xbox'] = xbl, 
--                         ['@discord'] = discord, 
--                         ['@ip'] = ip, 
--                         ['@moderator'] = xPlayer.getName(),
--                         ['@reason'] = message,
--                         ['@expiration'] = json.encode(date),
--                         ['@hourban'] = 999000,
--                         ['@permanent'] = 1
--                     })
--                     Wait(1000)
--                     MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
--                         ['@license'] = license
--                     }, function(result)
--                         table.insert(BanList, {
--                             idban      = result[1].idban or "Aucun",
--                             token      = GetPlayerToken(_src),
--                             license    = license,
--                             steam      = identifier,
--                             live       = live,
--                             xbl        = xbl,
--                             discord    = discord,
--                             ip         = ip,
--                             moderator  = xPlayer.getName() or "Inconnu",
--                             reason     = message,
--                             expiration = json.encode(date),
--                             hourban    = 999000,
--                             permanent  = 1
--                         })
--                         local endtime = os.time({year = date.year, month = date.month, day = date.day, hour = date.hour + CountHour, min = date.min, sec = date.sec})
--                         SendWebhookBan("Ban", "**Modérateur :** <@"..ids2.discord:gsub("discord:", "")..">\n**Joueur :** <@"..ids.discord:gsub("discord:", "")..">\n**ID Ban :** "..result[1].idban.."\n**Temps de ban :** Permanent\n**Raison :** "..message, "https://discord.com/api/webhooks/959520345788915764/A2KGTxmy73V6TqFf38GhmINdF0TBbH9bkgM6HY0oh_8n_-mqIdjEHXWnYgUifud8Afc4", '3863105')
--                         DropPlayer(_src, "Vous êtes ban de Offline\nRaison : "..message.."\nID Bannissement : "..result[1].idban)
--                     end)
--                 else
--                     MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban)', {
--                         ['@token'] = GetPlayerToken(_src),
--                         ['@license'] = license, 
--                         ['@identifier'] = identifier,
--                         ['@liveid'] = live,
--                         ['@xbox'] = xbl, 
--                         ['@discord'] = discord,
--                         ['@ip'] = ip, 
--                         ['@moderator'] = xPlayer.getName(),
--                         ['@reason'] = message,
--                         ['@expiration'] = json.encode(date),
--                         ['@hourban'] = CountHour
--                     })
--                     Wait(1000)
--                     MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
--                         ['@license'] = license
--                     }, function(result)
--                         table.insert(BanList, {
--                             idban      = result[1].idban or "Aucun",
--                             token      = GetPlayerToken(_src),
--                             license    = license,
--                             steam      = identifier,
--                             live       = live,
--                             xbl        = xbl,
--                             discord    = discord,
--                             ip         = ip,
--                             moderator  = xPlayer.getName(),
--                             reason     = message,
--                             expiration = json.encode(date),
--                             hourban    = CountHour,
--                             permanent  = 0
--                         })
--                         local endtime = os.time({year = date.year, month = date.month, day = date.day, hour = date.hour + CountHour, min = date.min, sec = date.sec})
--                         SendWebhookBan("Ban", "**Modérateur :** <@"..ids2.discord:gsub("discord:", "")..">\n**Joueur :** <@"..ids.discord:gsub("discord:", "")..">\n**ID Ban :** "..result[1].idban.."\n**Temps de ban :** "..CountHour.."Heures\n**Date unban :** "..os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime).."\n**Raison :** "..message, "https://discord.com/api/webhooks/959520345788915764/A2KGTxmy73V6TqFf38GhmINdF0TBbH9bkgM6HY0oh_8n_-mqIdjEHXWnYgUifud8Afc4", '3863105')
--                         DropPlayer(_src, "Vous êtes ban de Offline\nRaison : "..message.."\nID Bannissement : "..result[1].idban)
--                     end)
--                 end
--             end
--         end
--     end
-- end, false)

-- RegisterCommand("banoff", function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
--         if args[1] and args[2] then
--             local license = args[1]
--             local CountHour = args[2]
--             local ids2 = ExtractIdentifiersBan(source)
            
--             MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {
--                 ['@license'] = license
--             }, function(result)
--                 if json.encode(result[1].infoban) ~= "null" then
--                     local info = json.decode(result[1].infoban)
--                     local identifier = result[1].identifier
--                     local token = info.token
--                     local live = info.live
--                     local xbl = info.xbl
--                     local discordd = info.discord
--                     local ip = info.ip
--                     local date = {
--                         year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
--                     }

--                     if identifier == nil then
--                         identifier = 'Aucun'
--                     end
--                     if live == nil then
--                         live = 'Aucun'
--                     end
--                     if xbl == nil then
--                         xbl = 'Aucun'
--                     end
--                     if discordd == nil then
--                         discordd = 'Aucun'
--                     end
--                     if ip == nil then
--                         ip = 'Aucun'
--                     end

--                     sm = stringsplit(rawCommand, " ")
--                     message = ""
--                     for i = 4, #sm do
--                         message = message ..sm[i].. " "
--                     end

--                     if tonumber(CountHour) == tonumber(0) then
--                         MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban, permanent) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban, @permanent)', {
--                             ['@token'] = token,
--                             ['@license'] = license, 
--                             ['@identifier'] = identifier, 
--                             ['@liveid'] = live, 
--                             ['@xbox'] = xbl, 
--                             ['@discord'] = discordd, 
--                             ['@ip'] = ip, 
--                             ['@moderator'] = xPlayer.getName(),
--                             ['@reason'] = message,
--                             ['@expiration'] = json.encode(date),
--                             ['@hourban'] = 999000,
--                             ['@permanent'] = 1
--                         })
--                         Wait(2000)
--                         MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
--                             ['@license'] = license
--                         }, function(row)
--                             table.insert(BanList, {
--                                 idban      = row[1].idban or "Aucun",
--                                 token      = token,
--                                 license    = license,
--                                 steam      = identifier,
--                                 live       = live,
--                                 xbl        = xbl,
--                                 discord    = discordd,
--                                 ip         = ip,
--                                 moderator  = xPlayer.getName(),
--                                 reason     = message,
--                                 expiration = json.encode(date),
--                                 hourban    = 999000,
--                                 permanent  = 1
--                             })
--                             SendWebhookBan("Ban", "**Modérateur :** <@"..ids2.discord:gsub("discord:", "")..">\n**Joueur :** <@"..discordd:gsub("discord:", "")..">\n**ID Ban :** "..row[1].idban.."\n**Temps de ban :** Permanent".."\n**Raison :** "..message, "https://discord.com/api/webhooks/959520345788915764/A2KGTxmy73V6TqFf38GhmINdF0TBbH9bkgM6HY0oh_8n_-mqIdjEHXWnYgUifud8Afc4", '3863105')
--                         end)
--                     else
--                         MySQL.Async.execute('INSERT INTO banlist (token, license, identifier, liveid, xbox, discord, ip, moderator, reason, expiration, hourban) VALUES (@token, @license, @identifier, @liveid, @xbox, @discord, @ip, @moderator, @reason, @expiration, @hourban)', {
--                             ['@token'] = token,
--                             ['@license'] = license, 
--                             ['@identifier'] = identifier,
--                             ['@liveid'] = live,
--                             ['@xbox'] = xbl, 
--                             ['@discord'] = discordd,
--                             ['@ip'] = ip, 
--                             ['@moderator'] = xPlayer.getName(),
--                             ['@reason'] = message,
--                             ['@expiration'] = json.encode(date),
--                             ['@hourban'] = CountHour
--                         })
--                         Wait(2000)
--                         MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', {
--                             ['@license'] = license
--                         }, function(row2)
--                             table.insert(BanList, {
--                                 idban      = row2[1].idban or "Aucun",
--                                 token      = token,
--                                 license    = license,
--                                 steam      = identifier,
--                                 live       = live,
--                                 xbl        = xbl,
--                                 discord    = discordd,
--                                 ip         = ip,
--                                 moderator  = xPlayer.getName(),
--                                 reason     = message,
--                                 expiration = json.encode(date),
--                                 hourban    = CountHour,
--                                 permanent  = 0
--                             })
--                             local endtime = os.time({year = date.year, month = date.month, day = date.day, hour = date.hour + CountHour, min = date.min, sec = date.sec})
--                             SendWebhookBan("Ban", "**Modérateur :** <@"..ids2.discord:gsub("discord:", "")..">\n**Joueur :** <@"..discordd:gsub("discord:", "")..">\n**ID Ban :** "..row2[1].idban.."\n**Temps de ban :** "..CountHour.."Heures\n**Date unban :** "..os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime).."\n**Raison :** "..message, "https://discord.com/api/webhooks/959520345788915764/A2KGTxmy73V6TqFf38GhmINdF0TBbH9bkgM6HY0oh_8n_-mqIdjEHXWnYgUifud8Afc4", '3863105')
--                         end)
--                     end
--                 else
--                     xPlayer.showNotification("~r~ERREUR Licence inexistante ou la personne ne ses jamais connecter au serveur.")
--                 end
--             end)
--         else
--             xPlayer.showNotification("~r~ERREUR Veuillez bien mettre une license inexistante un temps de ban et une raison.")
--         end
--     end
-- end, false)

-- RegisterCommand("unban", function(source, args, rawCommand)
--     local _src = source
--     local xPlayer = ESX.GetPlayerFromId(_src)
--     local ids = ExtractIdentifiersBan(_src)
--     local Argz = args[1]

--     if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
--         if Argz ~= nil then
--             for i = 1, #BanList, 1 do
--                 if tonumber(BanList[i].idban) == tonumber(Argz) then
--                     table.remove(BanList, i)
--                     MySQL.Async.execute("DELETE FROM `banlist` WHERE `idban` = @idban", {
--                         ["@idban"] = tonumber(Argz),
--                     })
--                     SendWebhookBan("Unban", "**Modérateur :** <@"..ids.discord:gsub("discord:", "")..">\n**ID unban :** "..Argz, "https://discord.com/api/webhooks/959180899071717408/qvhXR-QIEjSiu8GRQjMnUP_ivMemrKlL8Q1mAkTxtYDCE-b17bCdACzv-hagMDkWcuwX", '3863105')
--                     break
--                 end
--             end
--         end
--     end
-- end, false)