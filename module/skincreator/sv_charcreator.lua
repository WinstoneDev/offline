Offline.RegisterServerEvent("SetBucket", function(number)
    local _src = source
    SetPlayerRoutingBucket(_src, number)
end)

Offline.RegisterServerEvent('offline:saveskin', function(skin)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    MySQL.Async.execute('UPDATE players SET skin = @skin WHERE id = @id', {
        ['@skin'] = json.encode(skin),
        ['@id'] = player.id
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
    local player = Offline.GetPlayerFromId(_src)
    MySQL.Async.execute("UPDATE players SET characterInfos = @characterInfos WHERE id = @id", {
        ["@id"] = player.id,
        ["@characterInfos"] = json.encode(infos)
    })

    player.characterInfos = infos

    if Offline.Inventory.CanCarryItem(player, 'burger', 5) then
        Offline.Inventory.AddItemInInventory(player, "burger", 5, 'BurgerShot MaxiBeef')
    end
    if Offline.Inventory.CanCarryItem(player, 'sprunk', 5) then
        Offline.Inventory.AddItemInInventory(player, "sprunk", 5, 'Sprunk 33cl')
    end
end)