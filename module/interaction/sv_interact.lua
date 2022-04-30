RegisterCommand('giveitem', function(source, args)
    local _source = tonumber(args[1])
    Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_source], args[2], tonumber(args[3]))
end, false)

RegisterCommand('removeitem', function(source, args)
    local _source = tonumber(args[1])
    Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[_source], args[2], tonumber(args[3]))
end, false)

Offline.RegisterServerEvent('renameItemPlayer', function(source, name, lastLabel, newLabel, montant)
    Offline.Inventory.RenameItemLabel(Offline.ServerPlayers[source], name, lastLabel, newLabel, montant)
end)

Offline.RegisterServerEvent('removeItemPlayer', function(source, item, quantity, itemLabel)
    Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[source], item, quantity, itemLabel)
end)