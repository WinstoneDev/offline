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
                amountMoney = result[i].amountMoney,
                transactions = json.decode(result[i].transactions),
                courant = Offline.ConverToBoolean(result[i].courant)
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
    blipName = "Banque"
}, true, {
    drawNotificationDistance = 1.7,
    notificationMessage = "Appuyez sur ~INPUT_CONTEXT~ pour parler à Bob",
}, true, {
    coords = vector4(243.74, 226.52, 105.3, 170.0),
    pedName = "Bob",
    pedModel = "cs_bankman",
    drawDistName = 5.0
})

Offline.RegisterServerEvent('offline:GetBankAccounts', function()
    local accounts = Offline.Bank.GetPersonnalAccounts(Offline.ServerPlayers[source].identifier)
    Offline.SendEventToClient('offline:receiveBankAccounts', source, accounts)
end)

Offline.RegisterServerEvent('offline:BankCreateAccount', function()
    local player = Offline.ServerPlayers[source]
    local account = {
        owner = player.identifier,
        owner_name = player.characterInfos.Prenom .. " " .. player.characterInfos.NDF,
        amountMoney = 0,
        transactions = {},
        courant = false
    }
    MySQL.Async.execute('INSERT INTO bankaccounts (owner, owner_name, amountMoney, transactions, courant) VALUES  (@owner, @owner_name, @amountMoney, @transactions, @courant)', {
        ['@owner'] = account.owner,
        ['@owner_name'] = account.owner_name,
        ['@amountMoney'] = account.amountMoney,
        ['@transactions'] = json.encode(account.transactions),
        ['@courant'] = Offline.ConverToNumber(account.courant)
    })
    Wait(150)
    Offline.Bank.GetAllAccounts()
    Wait(150)
    local accounts = Offline.Bank.GetPersonnalAccounts(player.identifier)
    Offline.SendEventToClient('offline:receiveBankAccounts', player.source, accounts)
    Offline.SendEventToClient('offline:notify', player.source, '~r~Maze Bank~s~\nVotre compte a été ~g~créé~s~ avec succès.')
end)