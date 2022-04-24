RegisterCommand('test', function(source)
    local _source = source
    _Offline_Inventory_.AddItemInInventory(_Offline_Server_.ServerPlayers[_source], 'bread', 1)
end, false)

RegisterCommand('test2', function(source)
    local _source = source
    _Offline_Inventory_.RemoveItemInInventory(_Offline_Server_.ServerPlayers[_source], 'bread', 1)
end, false)

RegisterCommand('test3', function(source)
    local _source = source
    _Offline_Inventory_.RenameItemLabel(_Offline_Server_.ServerPlayers[_source], 'bread', 'Pain', 'Altix', 1)
end, false)