
_Offline_Server_.RegisterServerEvent("Inventory:RenameItem", function(item, labelOfItem, labelToPut, quantity)
    local _source = source
    local player = _Offline_Server_.GetPlayerFromdId(_source)
    _Offline_Inventory_.RenameItemLabel(player, item, labelOfItem, labelToPut, quantity)
end)

RegisterCommand('test', function(source)
    local _source = source
    _Offline_Inventory_.AddItemInInventory(_Offline_Server_.ServerPlayers[_source], 'bread', 1)
end, false)

RegisterCommand('test2', function(source)
    local _source = source
    _Offline_Inventory_.RemoveItemInInventory(_Offline_Server_.ServerPlayers[_source], 'bread', 1)
end, false)