Offline.Bank = {}
Offline.Bank.BankAccounts = {}

MySQL.ready(function()
    Offline.Bank.GetAllAccounts()
end)

Offline.Bank.GetAllAccounts = function()
    Offline.Bank.BankAccounts = {}
    MySQL.Async.fetchAll('SELECT * FROM bankaccounts', {}, function(result)
        for i = 1, #result, 1 do
            Offline.Bank.BankAccounts[result[i].id] = {
                id = result[i].id,
                owner = result[i].owner,
                owner_name = result[i].owner_name,
                iban = result[i].iban,
                amountMoney = result[i].amountMoney,
                transactions = json.decode(result[i].transactions),
                courant = result[i].courant,
                card_infos = json.decode(result[i].card_infos)
            }
        end
    end)
end

Offline.Bank.GetPersonnalAccounts = function(identifier)
    local accounts = {}
    for k, v in pairs(Offline.Bank.BankAccounts) do
        if v.owner == identifier then
            table.insert(accounts, v)
        end
    end
    return accounts
end

Offline.RegisterZone('Guichet de banque', vector3(243.2082, 224.7312, 106.2869), function(source)
    Offline.SendEventToClient('offline:openBankMenu', source)
end, 10.0, false, {
    markerType = 25,
    markerColor = {r = 0, g = 125, b = 255, a = 255},
    markerSize = {x = 1.0, y = 1.0, z = 1.0},
    markerPos = vector3(-1093.411, -809.2663, 19.2816)
}, true, {
    blipSprite = 207,
    blipColor = 2,
    blipScale = 0.7,
    blipName = "Pacific Standard Bank"
}, true, {
    drawNotificationDistance = 1.7,
    notificationMessage = "Appuyez sur ~INPUT_CONTEXT~ pour parler à Bob",
}, true, {
    coords = vector4(243.74, 226.52, 105.3, 170.0),
    pedName = "Bob",
    pedModel = "cs_bankman",
    drawDistName = 5.0,
    scenario = {
        anim = "WORLD_HUMAN_CLIPBOARD"
    }
})

Offline.RegisterServerEvent('offline:GetBankAccounts', function()
    Offline.SendEventToClient('offline:receiveBankAccounts', source, Offline.Bank.BankAccounts)
end)

Offline.RegisterServerEvent('offline:BankCreateAccount', function()
    local player = Offline.GetPlayerFromId(source)
    local account = {
        owner = player.identifier,
        owner_name = player.characterInfos.Prenom .. " " .. player.characterInfos.NDF,
        amountMoney = 0,
        transactions = {},
        courant = false
    }
    MySQL.Async.execute('INSERT INTO bankaccounts (owner, owner_name, iban, amountMoney, transactions, courant) VALUES  (@owner, @owner_name, @iban, @amountMoney, @transactions, @courant)', {
        ['@owner'] = account.owner,
        ['@owner_name'] = account.owner_name,
        ['@iban'] = Offline.Bank.GenerateIBAN(25),
        ['@amountMoney'] = account.amountMoney,
        ['@transactions'] = json.encode(account.transactions),
        ['@courant'] = Offline.ConverToNumber(account.courant)
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
    Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVotre compte a été ~g~créé~s~ avec succès.')
end)

Offline.RegisterServerEvent('offline:BankChangeAccountStatus', function(id, state)
    local player = Offline.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE bankaccounts SET courant = @courant WHERE id = @id', {
        ['@id'] = id,
        ['@courant'] = state
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
    Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVotre compte a été ~g~modifié~s~ avec succès.')
end)

Offline.RegisterServerEvent('offline:BankDeleteAccount', function(id)
    local player = Offline.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM bankaccounts WHERE id = @id', {
        ['@id'] = id
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
    Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVotre compte a été ~g~supprimé~s~ avec succès.')
end)


Offline.RegisterServerEvent('offline:BankCreateCard', function(id)
    local player = Offline.GetPlayerFromId(source)
    local card = {
        owner_name = player.characterInfos.Prenom .. " " .. player.characterInfos.NDF,
        card_number = Offline.Bank.GenerateCardNumber(),
        card_pin = Offline.Bank.GenerateCardPin(),
        card_cvv = Offline.Bank.GenerateCardCVV(),
        card_expiration_date = Offline.Bank.GenerateCardExpirationDate(),
        card_type = 'Mastercard',
        card_account = id
    }
    MySQL.Async.execute('UPDATE bankaccounts SET card_infos = @card_infos WHERE id = @id', {
        ['@id'] = id,
        ['@card_infos'] = json.encode(card)
    })
    if Offline.Inventory.CanCarryItem(player, 'carte', 1) then
        Offline.Inventory.AddItemInInventory(player, 'carte', 1, 'Compte n°' ..id, nil, card)
    end
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
    Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVotre carte a été ~g~créée~s~ avec succès.')
end)

Offline.Bank.GetAccount = function(id)
    local account = nil
    for k, v in pairs(Offline.Bank.BankAccounts) do
        if v.id == id then
            account = v
            break
        end
    end
    return account
end

Offline.Bank.AddTransaction = function(account, amount, message, type)
    local player = Offline.GetPlayerFromId(source)
    local transaction = {
        amount = amount,
        type = type,
        message = message,
        date = os.date('%d/%m/%Y %H:%M:%S')
    }
    table.insert(account.transactions, transaction)
    MySQL.Async.execute('UPDATE bankaccounts SET transactions = @transactions WHERE id = @id', {
        ['@id'] = account.id,
        ['@transactions'] = json.encode(account.transactions)
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
end

Offline.Bank.UpdateAccount = function(account, amount)
    local player = Offline.GetPlayerFromId(source)
    account.amountMoney = amount
    MySQL.Async.execute('UPDATE bankaccounts SET amountMoney = @amountMoney WHERE id = @id', {
        ['@id'] = account.id,
        ['@amountMoney'] = account.amountMoney
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, Offline.Bank.BankAccounts)
end

Offline.RegisterServerEvent('offline:BankAddMoney', function(amount, id)
    local player = Offline.GetPlayerFromId(source)
    local account = Offline.Bank.GetAccount(id)
    if account ~= nil then
        if Offline.Money.GetPlayerMoney(player) >= tonumber(amount) then
            Offline.Money.RemovePlayerMoney(player, amount)
            Offline.Bank.UpdateAccount(account, account.amountMoney + amount)
            Offline.Bank.AddTransaction(account, amount, 'Ajout de '..amount..'$', 'Dépôt')
            Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVous avez ajouté ~g~' .. amount .. '$~s~ à votre compte.')
        else
            Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVous n\'avez pas assez d\'argent.')
        end
    end
end)

Offline.RegisterServerEvent('offline:BankwithdrawMoney', function(amount, id)
    local player = Offline.GetPlayerFromId(source)
    local account = Offline.Bank.GetAccount(id)
    if tonumber(account.amountMoney) >= tonumber(amount) then
        Offline.Bank.AddTransaction(account, amount, 'Retrait de ' .. amount .. '$', 'Retrait')
        Offline.Bank.UpdateAccount(account, account.amountMoney - amount)
        Offline.Money.AddPlayerMoney(player, amount)
        Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVous avez retiré ~g~' .. amount .. '$~s~ avec succès.')
    else
        Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVous n\'avez pas assez d\'argent sur votre compte.')
    end
end)

Offline.Bank.GenerateCardNumber = function()
    local number = ''
    for i = 1, 16 do
        number = number .. math.random(0, 9)
    end
    return number
end

Offline.Bank.GenerateCardPin = function()
    local pin = ''
    for i = 1, 4 do
        pin = pin .. math.random(0, 9)
    end
    return pin
end 

Offline.Bank.GenerateCardCVV = function()
    return math.random(100, 999)
end

Offline.Bank.GenerateCardExpirationDate = function()
    local month = math.random(1, 12)
    local year = math.random(2022, 2030)
    return month .. '/' .. year
end

Offline.Bank.GenerateIBAN = function(length)
    local string = ""
    for i = 1, length, 1 do
        local random = math.random(0, 1)
        if random == 0 then
            string = string .. math.random(0, 9)
        else
            string = string .. string.char(math.random(65, 90))
        end
    end

    string = 'OFF' .. string

    local exist = false

    for key, value in pairs(Offline.Bank.BankAccounts) do
        if value.iban == string then
            exist = true
            break
        end
    end

    if exist then
        Offline.Bank.GenerateIBAN(length)
    else
        return string
    end
end

Offline.RegisterUsableItem('carte', function(data)
    local _src = source
    local player = Offline.GetPlayerFromId(source)
    Offline.SendEventToClient('offline:useCarteBank', player.source, data)
end)