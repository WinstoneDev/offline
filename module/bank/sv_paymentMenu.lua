Offline.RegisterServerEvent('offline:attemptToPayMenu', function(transactionMessage, price)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    local inventory = player.inventory
    Offline.SendEventToClient('offline:openPaymentMenu', player.source, transactionMessage, price, inventory)
end)

Offline.RegisterServerEvent('offline:pay', function(codePin, price, type, cardInfos, transactionMessage)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)
    if type == "money" then
        local money = Offline.Money.GetPlayerMoney(player)
        if money >= tonumber(price) then
            Offline.Money.RemovePlayerMoney(player, price)
            Offline.SendEventToClient('offline:doActionsPayment', player.source, true)
            Offline.SendEventToClient('offline:notify', player.source, '~g~Vous avez payé ' .. price .. '$')
        else
            Offline.SendEventToClient('offline:doActionsPayment', player.source, false)
            Offline.SendEventToClient('offline:notify', player.source, '~r~Vous n\'avez pas assez d\'argent')
        end
    elseif type == "bank" then
        local account = Offline.Bank.GetAccount(cardInfos.data.card_account)
        if account then
            if account.card_infos.card_pin == codePin then
                if account.amountMoney >= price then
                    Offline.Bank.AddTransaction(account, price, transactionMessage, 'Achat')
                    Offline.Bank.UpdateAccount(account, account.amountMoney - price)
                    Offline.SendEventToClient('offline:doActionsPayment', player.source, true)
                    Offline.SendEventToClient('offline:notify', player.source, '~g~Vous avez payé ' .. price .. '$')
                else
                    Offline.SendEventToClient('offline:notify', player.source, '~r~La carte n\'a pas assez d\'argent')
                    Offline.SendEventToClient('offline:doActionsPayment', player.source, false)
                end
            else
                DropPlayer(player.source, '╭∩╮（︶_︶）╭∩╮')
            end
        else
            DropPlayer(player.source, '╭∩╮（︶_︶）╭∩╮')
        end
    end
end)