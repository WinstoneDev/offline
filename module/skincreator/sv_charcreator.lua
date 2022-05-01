Offline.RegisterServerEvent("SetBucket", function(number)
    local _src = source
    SetPlayerRoutingBucket(_src, number)
end)

Offline.RegisterServerEvent('offline:saveskin', function(skin)
    local _src = source
    MySQL.Async.execute('UPDATE players SET skin = @skin WHERE id = @id', {
        ['@skin'] = json.encode(skin),
        ['@id'] = Offline.ServerPlayers[_src].id
    })
end)

Offline.RegisterServerEvent("SetIdentity", function(NDF, Prenom, DDN, Sexe, Taille, LDN)
    local _src = source
    local infos = {
        NDF = NDF,
        Prenom = Prenom,
        DDN = DDN,
        Sexe = Sexe,
        Taille = Taille,
        LDN = LDN
    }
    MySQL.Async.execute("UPDATE players SET characterInfos = @characterInfos WHERE id = @id", {
        ["@id"] = Offline.ServerPlayers[_src].id,
        ["@characterInfos"] = json.encode(infos)
    })

    Offline.ServerPlayers[_src].characterInfos = infos

    if Offline.Inventory.CanCarryItem(Offline.ServerPlayers[_src], 'burger', 5) then
        Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_src], "burger", 5, 'BurgerShot MaxiBeef')
    end
    if Offline.Inventory.CanCarryItem(Offline.ServerPlayers[_src], 'sprunk', 5) then
        Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_src], "sprunk", 5, 'Sprunk 33cl')
    end
end)