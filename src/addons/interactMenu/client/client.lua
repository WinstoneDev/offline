local interactMenu = {
    opened = false,
    selectedItem = nil
}

interactMenu.mainMenu = RageUI.CreateMenu("Interact", "Interact Menu")
interactMenu.inventoryMenu = RageUI.CreateSubMenu(interactMenu.mainMenu, "Inventory", "Inventory Menu")
interactMenu.inventoryActionsMenu = RageUI.CreateSubMenu(interactMenu.inventoryMenu, "Actions", "Actions Menu")
interactMenu.walletMenu = RageUI.CreateSubMenu(interactMenu.mainMenu, "Wallet", "Wallet Menu")

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
                    RageUI.Button(item.label .. ' x'  .. item.quantity, nil, {}, true, {
                        onSelected = function()
                            interactMenu.selectedItem = item
                            RageUI.Visible(interactMenu.inventoryActionsMenu, true)
                        end
                    })
                end
            end)
            RageUI.IsVisible(interactMenu.walletMenu, function()
            end)
            RageUI.IsVisible(interactMenu.inventoryActionsMenu, function()
                RageUI.Button('Renommer', 'Renommer l\'item '..interactMenu.selectedItem.label, {RightLabel = "→"}, true, {
                    onSelected = function()
                        local label = _Offline_Client_.KeyboardInput('Nom', 10)
                        local quantity = _Offline_Client_.KeyboardInput('Quantité', 10)
                        if label and label ~= nil and quantity and quantity ~= nil then
                            _Offline_Client_.SendEventToServer('Inventory:RenameItem', interactMenu.selectedItem.name, interactMenu.selectedItem.label, label, tonumber(quantity))
                            RageUI.GoBack()
                        else
                            TriggerEvent("WaveNotify","error", "Veuillez réessayer", "Erreur rencontrée","Erreur")
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