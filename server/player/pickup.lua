---@class Offline.Pickup
Offline.Pickup = {}
Offline.PickupId = 0

Offline.RegisterServerEvent('offline:addItemPickup', function(itemName, itemType, itemLabel, itemCount, itemCoords, uniqueId, data)
	local _src = source
    local player = Offline.GetPlayerFromId(_src)
    if itemType == "item_standard" then
        local item = Offline.Inventory.GetInventoryItem(player, itemName)

        if item.count > 0 then
            if item.count >= itemCount then
                local pickupId = Offline.PickupId + 1
                local pTable = {id = pickupId, name = itemName, label = itemLabel, count = itemCount, model = Config.Items[itemName].props or "v_serv_abox_02", coords = itemCoords, uniqueId = uniqueId, data = data, type = itemType}
                Offline.Pickup[pickupId] = pTable
                Offline.PickupId = pickupId
                Offline.Inventory.RemoveItemInInventory(player, itemName, itemCount, itemLabel)
                Offline.SendEventToClient('offline:interactItemPickup', -1, "create", pTable)
                Offline.SendEventToClient('offline:notify', _src, itemCount..' '..itemLabel..' ont été ~r~retiré(s)~s~ à votre inventaire.')
            else
                Offline.SendEventToClient('offline:notify', _src, 'Vous n\'avez pas assez de '..itemLabel..'.')
            end
        end
    end

    if itemType == nil then
        if itemName == 'item_cash' then
            local cash = Offline.Money.GetPlayerMoney(player)
            if tonumber(cash) >= tonumber(itemCount) then
                local pickupId = Offline.PickupId + 1
                local pTable = {id = pickupId, name = itemName, label = itemLabel, count = itemCount, model = "v_serv_abox_02", coords = itemCoords, type = itemName}
                Offline.Pickup[pickupId] = pTable
                Offline.PickupId = pickupId
                Offline.Money.RemovePlayerMoney(player, itemCount)
                Offline.SendEventToClient('offline:interactItemPickup', -1, "create", pTable)
                Offline.SendEventToClient('offline:notify', _src, itemCount..'$ ont été retiré(s) à votre inventaire.')
            else
                Offline.SendEventToClient('offline:notify', _src, 'Vous n\'avez pas assez de $.')
            end
        end
        if itemName == 'item_dirty' then
            local dirty = Offline.Money.GetPlayerDirtyMoney(player)
            if dirty >= itemCount then
                local pickupId = Offline.PickupId + 1
                local pTable = {id = pickupId, name = itemName, label = itemLabel, count = itemCount, model = "v_serv_abox_02", coords = itemCoords, itemType = itemName}
                Offline.Pickup[pickupId] = pTable
                Offline.PickupId = pickupId
                Offline.Money.RemovePlayerDirtyMoney(player, itemCount)
                Offline.SendEventToClient('offline:interactItemPickup', -1, "create", pTable)
                Offline.SendEventToClient('offline:notify', _src, itemCount..'$ ont été retiré(s) à votre inventaire.')
            else
                Offline.SendEventToClient('offline:notify', _src, 'Vous n\'avez pas assez de $.')
            end
        end 
    end
end)

Offline.RegisterServerEvent('offline:removeItemPickup', function(data)
    local _src = source
    local player = Offline.GetPlayerFromId(_src)

    if #(GetEntityCoords(GetPlayerPed(_src)) - data.coords) <= 5.5 then
        if Offline.Pickup[data.id] then
                if data.type == 'item_cash' then
                    Offline.Pickup[data.id] = nil
                    Offline.Money.AddPlayerMoney(player, data.count)
                    Offline.SendEventToClient('offline:notify', _src, data.count..'$ ont été ajouté(s) à votre inventaire.')
                    Offline.SendEventToClient('offline:interactItemPickup', -1, "retrieve", data)
                end

                if data.type == 'item_dirty' then
                    Offline.Pickup[data.id] = nil
                    Offline.Money.AddPlayerDirtyMoney(player, data.count)
                    Offline.SendEventToClient('offline:notify', _src, data.count..'$ ont été ajouté(s) à votre inventaire.')
                    Offline.SendEventToClient('offline:interactItemPickup', -1, "retrieve", data)
                end

                if data.type == "item_standard" then
                    if Offline.Inventory.CanCarryItem(player, data.name, tonumber(data.count)) then
                        Offline.Pickup[data.id] = nil
                        Offline.Inventory.AddItemInInventory(player, data.name, tonumber(data.count), data.label, data.uniqueId, data.data)
                        Offline.SendEventToClient('offline:interactItemPickup', -1, "retrieve", data)
                        Offline.SendEventToClient('offline:notify', _src, data.count..' '..data.label..' ont été ~g~ajouté(s)~s~ à votre inventaire.')
                    else
                        Offline.SendEventToClient('offline:notify', source, '~r~Vous n\'avez plus de place.')
                    end
                end
        else
            Offline.SendEventToClient('offline:notify', source, '~r~ERREUR.')
        end
    end
end)