RegisterCommand('test', function(source)
    local _source = source
    _Offline_Inventory_.AddItemInInventory(_Offline_Server_.ServerPlayers[_source], 'bread', 1)
end, false)