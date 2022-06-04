Offline.RegisterServerEvent('offline:attemptToPayMenu', function(transactionMessage, price, actions)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    local inventory = player.inventory
    Offline.SendEventToClient('offline:openPaymentMenu', player.source, transactionMessage, price, inventory, actions)
end)

Offline.RegisterServerEvent('offline:pay', function(codePin, price, type, cardInfos, actions)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)

    print(json.encode(actions))

    if type == "money" then
        local money = Offline.Money.GetPlayerMoney(player)
        if money >= tonumber(price) then
            Offline.Money.RemovePlayerMoney(player, price)
            Offline.SendEventToClient('offline:doActionsPayment', player.source, true, actions)
            Offline.SendEventToClient('offline:notify', player.source, '~g~Vous avez payé ' .. price .. '$')
        else
            ffline.SendEventToClient('offline:doActionsPayment', player.source, false, actions)
            Offline.SendEventToClient('offline:notify', player.source, '~r~Vous n\'avez pas assez d\'argent')
        end
    elseif type == "bank" then

    end
end)