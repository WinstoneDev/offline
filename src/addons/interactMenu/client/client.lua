local interactMenu = {
    opened = false
}

interactMenu.mainMenu = RageUI.CreateMenu("Interact", "Interact Menu")
interactMenu.inventoryMenu = RageUI.CreateSubMenu(interactMenu.mainMenu, "Inventory", "Inventory Menu")
interactMenu.walletMenu = RageUI.CreateSubMenu(interactMenu.mainMenu, "Wallet", "Wallet Menu")
interactMenu.actionItem = RageUI.CreateSubMenu(interactMenu.inventoryMenu, "Inventory", "Inventory Action")


interactMenu.mainMenu.Closed = function()
    interactMenu.opened = false
    RageUI.Visible(interactMenu.mainMenu, false)
end

function interactMenu:OpenMenu()
    if interactMenu.opened then
        interactMenu.opened = false
        RageUI.Visible(interactMenu.mainMenu, false)
    else
        interactMenu.opened = true
        RageUI.Visible(interactMenu.mainMenu, true)
    end
    CreateThread(function()
        while interactMenu.opened do
            Wait(0)
            RageUI.IsVisible(interactMenu.mainMenu, function()
                RageUI.Button('Inventaire', nil, {}, true, {}, interactMenu.inventoryMenu)
                RageUI.Button('Porte-feuille', nil, {}, true, {}, interactMenu.walletMenu)
            end)
            RageUI.IsVisible(interactMenu.inventoryMenu, function()
                RageUI.Separator('Poids : '..GramsOrKg(_Offline_Player.weight)..' / '.._Offline_Config_.Informations["MaxWeight"]..'KG')
                for name, item in pairs(_Offline_Player.inventory) do
                    RageUI.Button(item.label..' x'..math.floor(item.count), nil, {}, true, {
                        onSelected = function()
                            interactMenu.Item = item.name
                            interactMenu.Label = item.label
                            Wait(150)
                            RageUI.CloseAll()
                            RageUI.Visible(interactMenu.actionItem, true)
                        end
                    })
                end
            end)
            RageUI.IsVisible(interactMenu.walletMenu, function()
            end)
            RageUI.IsVisible(interactMenu.actionItem, function()
                RageUI.Button("Utiliser", nil, {}, true, {})
                RageUI.Button("Donner", nil, {}, true, {})
                RageUI.Button("Rename", nil, {}, true, {
                    onSelected = function()
                        local result = _Offline_Client_.KeyboardInput("Label", 30)
                        if result ~= nil and #result > 2 then
                            _Offline_Client_.SendEventToServer('renameItemPlayer', GetPlayerServerId(PlayerId()), interactMenu.Item, interactMenu.Label, result, 1)
                            RageUI.GoBack()
                        end
                    end
                })
                RageUI.Button("Jeter", nil, {}, true, {
                    onSelected = function()
                        local result = _Offline_Client_.KeyboardInput("Montant", 30)
                        if result ~= nil and tonumber(result) then
                            _Offline_Client_.SendEventToServer('removeItemPlayer', GetPlayerServerId(PlayerId()), interactMenu.Item, result, interactMenu.Label)
                            RageUI.GoBack()
                        end
                    end
                })
            end)
        end
    end)
end

Keys.Register("F5", "F5", "Ouvrir InteractMenu", function()
    interactMenu:OpenMenu()
end)

function GramsOrKg(weight)
    if weight >= 1 then
        return weight .. 'KG'
    else
        return weight*1000 .. 'G'
    end
end