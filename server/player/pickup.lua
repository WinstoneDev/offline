Offline.Pickup = {}
Offline.PickupId = 0

Offline.RegisterServerEvent('offline:addItemPickup', function(itemName, itemLabel, itemCount, itemCoords, uniqueId)
    if not itemName then return end
    if not itemLabel then return end
    if not itemCount then return end
    if not itemCoords then return end

	local _src = source
    local item = Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[_src], itemName)

    if item.count > 0 then
        if item.count >= itemCount then
            local pickupId = Offline.PickupId + 1
            local pTable = {id = pickupId, name = itemName, label = itemLabel, count = itemCount, model = Config.Items[itemName].props or "v_serv_abox_02", coords = itemCoords, uniqueId = uniqueId}
            Offline.Pickup[pickupId] = pTable
            Offline.PickupId = pickupId
            Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[_src], itemName, itemCount, itemLabel)
            Offline.SendEventToClient('offline:interactItemPickup', -1, "create", pTable)
            Offline.SendEventToClient('offline:notify', _src, itemCount..' '..itemLabel..' ont été ~r~retiré(s)~s~ à votre inventaire.')
        else
            Offline.SendEventToClient('offline:notify', _src, 'Vous n\'avez pas assez de '..itemLabel..'.')
        end
    end
end)

Offline.RegisterServerEvent('offline:removeItemPickup', function(data)
    local _src = source

    if #(GetEntityCoords(GetPlayerPed(_src)) - data.coords) <= 5.5 then
        if Offline.Pickup[data.id] then
            if Offline.Inventory.CanCarryItem(Offline.ServerPlayers[_src], data.name, tonumber(data.count)) then
                Offline.Pickup[data.id] = nil
                Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_src], data.name, tonumber(data.count), data.label, data.uniqueId)
                Offline.SendEventToClient('offline:interactItemPickup', -1, "retrieve", data)
                Offline.SendEventToClient('offline:notify', _src, data.count..' '..data.label..' ont été ~g~ajouté(s)~s~ à votre inventaire.')
            else
                Offline.SendEventToClient('offline:notify', source, '~r~Vous n\'avez plus de place.')
            end
        else
            Offline.SendEventToClient('offline:notify', source, '~r~ERREUR.')
        end
    end
end)