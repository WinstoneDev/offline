RegisterCommand('giveitem', function(source, args)
    local _source = tonumber(args[1])
    Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_source], args[2], tonumber(args[3]), tonumber(args[4]))
end, false)