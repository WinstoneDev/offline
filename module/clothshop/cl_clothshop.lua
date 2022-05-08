local Clothes = {
    TableShirt = {},
    TableShoes = {},
    TableSacs = {},
    LastSkin = {},
    Variations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
}

function Clothes:loadLastSkin()
    TriggerEvent('skinchanger:loadSkin', Clothes.LastSkin) 
end

Clothes.mainMenu = RageUI.CreateMenu("", "Binco")
Clothes.subMenu = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu2 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu3 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu4 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu5 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu6 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")
Clothes.subMenu7 = RageUI.CreateSubMenu(Clothes.mainMenu, "", "Binco")

Clothes.mainMenu:DisplayGlare(false)
Clothes.subMenu:DisplayGlare(false)
Clothes.subMenu2:DisplayGlare(false)
Clothes.subMenu3:DisplayGlare(false)
Clothes.subMenu4:DisplayGlare(false)
Clothes.subMenu5:DisplayGlare(false)
Clothes.subMenu6:DisplayGlare(false)
Clothes.subMenu7:DisplayGlare(false)
Clothes.subMenu:AcceptFilter(true)
Clothes.subMenu2:AcceptFilter(true)
Clothes.subMenu3:AcceptFilter(true)
Clothes.subMenu4:AcceptFilter(true)
Clothes.subMenu5:AcceptFilter(true)
Clothes.subMenu6:AcceptFilter(true)
Clothes.subMenu7:AcceptFilter(true)

Clothes.mainMenu.Closed = function()
    Clothes.opened = false
    RageUI.Visible(Clothes.mainMenu, false)
    Clothes:loadLastSkin()
end

function Clothes:OpenMenu(header)
    if RageUI.GetInMenu() then
        return
    end
    if Clothes.opened then
        Clothes.opened = false
        RageUI.Visible(Clothes.mainMenu, false)
    else
        Clothes.mainMenu:SetSpriteBanner(header, header)
        Clothes.subMenu:SetSpriteBanner(header, header)
        Clothes.subMenu2:SetSpriteBanner(header, header)
        Clothes.subMenu3:SetSpriteBanner(header, header)
        Clothes.subMenu4:SetSpriteBanner(header, header)
        Clothes.subMenu5:SetSpriteBanner(header, header)
        Clothes.subMenu6:SetSpriteBanner(header, header)
        Clothes.subMenu7:SetSpriteBanner(header, header)
        Clothes.opened = true
        RageUI.Visible(Clothes.mainMenu, true)
        Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
            Clothes.LastSkin = skin
        end)
        Offline.TriggerLocalEvent('skinchanger:getData', function(components, max)
            maxVals = {}
            maxVals["tshirt_1"] = max.tshirt_1
            maxVals["torso_1"] = max.torso_1
            maxVals["pants_1"] = max.pants_1
            maxVals["shoes_1"] = max.shoes_1
            maxVals["helmet_1"] = max.helmet_1
            maxVals["glasses_1"] = max.glasses_1
            maxVals["ears_1"] = max.ears_1
            maxVals["bags_1"] = max.bags_1
            maxVals["gloves_1"] = max.arms
            maxVals["watches_1"] = max.watches_1
            maxVals["bracelets_1"] = max.bracelets_1
            maxVals["chain_1"] = max.chain_1
            maxVals["decals_1"] = max.decals_1

            for i = 0, max.tshirt_1, 1 do
                Clothes.TableShirt[i] = 1
            end
            for i = 0, max.shoes_1, 1 do
                Clothes.TableShoes[i] = 1
            end
            for i = 0, max.bags_1, 1 do
                Clothes.TableSacs[i] = 1
            end
        end)
        Wait(550)
        CreateThread(function()
            while Clothes.opened do
                RageUI.IsVisible(Clothes.mainMenu, function()
                    RageUI.Button('Hauts', nil, {}, true, {}, Clothes.subMenu)
                    RageUI.Button('Pantalons', nil, {}, true, {}, Clothes.subMenu3)
                    RageUI.Button('Chaussures', nil, {}, true, {}, Clothes.subMenu4)
                    RageUI.Button('Sacs', nil, {}, true, {}, Clothes.subMenu5)
                    RageUI.Button('Accessoires', nil, {}, true, {}, Clothes.subMenu2)
                    RageUI.Button('Badge', nil, {}, true, {}, Clothes.subMenu6)
                    RageUI.Button('Objets', nil, {}, true, {}, Clothes.subMenu7)
                end)
                RageUI.IsVisible(Clothes.subMenu, function()

                end)
                RageUI.IsVisible(Clothes.subMenu2, function()

                end)
                RageUI.IsVisible(Clothes.subMenu3, function()
                    for i = 0, maxVals['pants_1'], 1 do          
                        RageUI.List("Pantalon #"..i, Clothes.Variations, Clothes.TableShirt[i], nil, {RightLabel = "~g~30$"}, true, {
                            onListChange = function(Index)
                                Clothes.TableShirt[i] = Index
                                Offline.TriggerLocalEvent('skinchanger:change', 'pants_2', Clothes.TableShirt[i] - 1)
                            end,
                            onSelected = function()    
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    Offline.SendEventToServer('offline:AddClothesInInventory', 'pants', 'Pantalon '..i, {skin.pants_1, skin.pants_2})
                                end)
                            end,
                            onActive = function()
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    if tonumber(skin.pants_1) ~= tonumber(i) then
                                        Offline.TriggerLocalEvent('skinchanger:change', 'pants_1', i)
                                    end
                                end)
                            end,
                        })
                    end
                end)
                RageUI.IsVisible(Clothes.subMenu4, function()
                    for i = 0, maxVals['shoes_1'], 1 do          
                        RageUI.List("Chaussure #"..i, Clothes.Variations, Clothes.TableShoes[i], nil, {RightLabel = "~g~30$"}, true, {
                            onListChange = function(Index)
                                Clothes.TableShoes[i] = Index
                                Offline.TriggerLocalEvent('skinchanger:change', 'shoes_2', Clothes.TableShoes[i] - 1)
                            end,
                            onSelected = function()
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    Offline.SendEventToServer('offline:AddClothesInInventory', 'shoes', 'Chaussure '..i, {skin.shoes_1, skin.shoes_2})
                                end)
                            end,
                            onActive = function()
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    if tonumber(skin.shoes_1) ~= tonumber(i) then
                                        Offline.TriggerLocalEvent('skinchanger:change', 'shoes_1', i)
                                    end
                                end)
                            end,
                        })
                    end
                end)
                RageUI.IsVisible(Clothes.subMenu5, function()
                    for i = 0, maxVals['bags_1'], 1 do          
                        RageUI.List("Sacs #"..i, Clothes.Variations, Clothes.TableSacs[i], nil, {RightLabel = "~g~30$"}, true, {
                            onListChange = function(Index)
                                Clothes.TableSacs[i] = Index
                                Offline.TriggerLocalEvent('skinchanger:change', 'bags_2', Clothes.TableSacs[i] - 1)
                            end,
                            onSelected = function()
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    Offline.SendEventToServer('offline:AddClothesInInventory', 'bags', 'Sacs '..i, {skin.bags_1, skin.bags_2})
                                end)
                            end,
                            onActive = function()
                                Offline.TriggerLocalEvent('skinchanger:getSkin', function(skin)
                                    if tonumber(skin.bags_1) ~= tonumber(i) then
                                        Offline.TriggerLocalEvent('skinchanger:change', 'bags_1', i)
                                    end
                                end)
                            end,
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

Offline.RegisterClientEvent('offline:openClothMenu', function(header)
    Clothes:OpenMenu(header)
end)