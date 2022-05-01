Offline.RegisterServerEvent('offline:AddClothesInInventory', function(item, label, data)
    local player = Offline.ServerPlayers[source]
    
    Offline.Inventory.AddItemInInventory(player, item, 1, label, data)
end)