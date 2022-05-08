Offline.RegisterServerEvent('offline:AddClothesInInventory', function(item, label, data)
    local player = Offline.ServerPlayers[source]
    
    Offline.Inventory.AddItemInInventory(player, item, 1, label, nil, data)
end)

local number = 0

for k,v in pairs(Config.zoneClothShop) do
    for i=1, #v, 1 do
        number = number + 1
        Offline.RegisterZone('Magasin de vêtements n°'..number, v[i].coords, function(source)
            Offline.SendEventToClient('offline:openClothMenu', source, v.Header)
        end, 10.0, true, {
            markerType = 25,
            markerColor = {r = 0, g = 125, b = 255, a = 255},
            markerSize = {x = 1.0, y = 1.0, z = 1.0},
            markerPos = v[i].coords
        }, true, {
            blipSprite = 73,
            blipColor = 81,
            blipScale = 0.7,
            blipName = "Magasin de vêtements"
        }, true, {
            drawNotificationDistance = 1.7,
            notificationMessage = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le magasin de vêtements",
        }, false, {})
    end
end