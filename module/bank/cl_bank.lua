local bankMenu = {
    opened = false,
    accounts = {},
    selectedAccount = nil
}

bankMenu.mainMenu = RageUI.CreateMenu(" ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
bankMenu.mainMenu:DisplayGlare(false)
bankMenu.accountsMenu = RageUI.CreateSubMenu(bankMenu.mainMenu, " ", "Comptes", nil, 100, "root_cause", "shopui_title_mazebank")
bankMenu.accountsMenu:DisplayGlare(false)
bankMenu.accountSelectedMenu = RageUI.CreateSubMenu(bankMenu.accountsMenu, " ", "Compte", nil, 100, "root_cause", "shopui_title_mazebank")
bankMenu.accountSelectedMenu:DisplayGlare(false)
bankMenu.transactionsMenu = RageUI.CreateSubMenu(bankMenu.accountSelectedMenu, " ", "Transactions", nil, 100, "root_cause", "shopui_title_mazebank")
bankMenu.transactionsMenu:DisplayGlare(false)

bankMenu.mainMenu.Closed = function()
    bankMenu.opened = false
end

bankMenu.OpenMenu = function()
    if RageUI.GetInMenu() then
        return
    end
    if bankMenu.opened then
        bankMenu.opened = false
        RageUI.Visible(bankMenu.mainMenu, false)
    else
        bankMenu.opened = true
        RageUI.Visible(bankMenu.mainMenu, true)
        CreateThread(function()
            while bankMenu.opened do
                Wait(0)
                RageUI.IsVisible(bankMenu.mainMenu, function()
                    RageUI.Button('Mes comptes banquaires', nil, {RightLabel = '→'}, true, {}, bankMenu.accountsMenu)
                    RageUI.Button('Créer un compte', nil, {RightLabel = '→'}, true, {
                        onSelected = function()
                            Offline.SendEventToServer('offline:BankCreateAccount')
                        end
                    })
                end)
                RageUI.IsVisible(bankMenu.accountsMenu, function()
                    if json.encode(bankMenu.accounts) == '[]' then
                        RageUI.Separator()
                        RageUI.Separator('↓ Aucun compte banquaire ↓')
                        RageUI.Separator()
                    else
                        for key, value in pairs(bankMenu.accounts) do
                            RageUI.Button('Compte n°'..value.id, nil, {RightLabel = '→'}, true, {
                                onSelected = function()
                                    bankMenu.selectedAccount = value
                                    RageUI.Visible(bankMenu.accountSelectedMenu, true)
                                end
                            })
                        end
                    end
                end)
                RageUI.IsVisible(bankMenu.accountSelectedMenu, function()
                    RageUI.Separator('↓ Compte ~g~n°'..bankMenu.selectedAccount.id..'~s~ ↓')
                    RageUI.Separator('Appartenant à ~b~'..bankMenu.selectedAccount.owner_name)
                    RageUI.Separator('Solde : ~g~'..bankMenu.selectedAccount.amountMoney..'$')
                    RageUI.Button('Liste des transactions', nil, {RightLabel = '→'}, true, {}, bankMenu.transactionsMenu)
                end)
                RageUI.IsVisible(bankMenu.transactionsMenu, function()
                    if json.encode(bankMenu.selectedAccount.transactions) == "[]" then
                        RageUI.Separator()
                        RageUI.Separator('↓ Aucune transaction ↓')
                        RageUI.Separator()
                    else
                        for key, value in pairs(bankMenu.selectedAccount.transactions) do
                            RageUI.Button('Transaction', nil, {RightLabel = '→'}, true, {})
                        end
                    end
                end)
            end
        end)
    end
end

Offline.RegisterClientEvent('offline:openBankMenu', function()
    Offline.SendEventToServer('offline:GetBankAccounts')
    bankMenu.OpenMenu()
end)

Offline.RegisterClientEvent('offline:receiveBankAccounts', function(accounts)
    bankMenu.accounts = accounts
end)