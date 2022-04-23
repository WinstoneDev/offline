local interactMenu = {
    opened = false
}

interactMenu.mainMenu = RageUI.CreateMenu("Interact", "Interact Menu")
interactMenu.inventoryMenu = RageUI.CreateSubMenu(interactMenu.mainMenu, "Inventory", "Inventory Menu")

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
            end)
            RageUI.IsVisible(interactMenu.inventoryMenu, function()
            end)
        end
    end)
end

Keys.Register("F5", "F5", "Ouvrir InteractMenu", interactMenu:OpenMenu())