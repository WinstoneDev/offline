Offline.RegisterServerEvent('offline:attemptToPayMenu', function(transactionMessage, price)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    local inventory = player.inventory
    Offline.SendEventToClient('offline:openPaymentMenu', player.source, transactionMessage, price, inventory)
end)