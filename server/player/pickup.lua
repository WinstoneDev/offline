Offline.Pickup = {}
Offline.PickupId = 0

Offline.RegisterServerEvent('offline:addItemPickup', function(itemName, itemLabel, itemCount, itemCoords)
    if not itemName then return end
    if not itemLabel then return end
    if not itemCount then return end
    if not itemCoords then return end

	local _src = source
    local item = Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[_src], itemName)

    if item.count > 0 then
        local pickupId = Offline.PickupId + 1
        local pTable = {id = pickupId, name = itemName, label = itemLabel, count = itemCount, model = Config.Items[itemName].props or "v_serv_abox_02", coords = itemCoords}
        Offline.Pickup[pickupId] = pTable
        Offline.PickupId = pickupId
        Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[_src], itemName, itemCount, itemLabel)
        Offline.SendEventToClient('offline:interactItemPickup', -1, "create", pTable)
    end
end)

Offline.RegisterServerEvent('offline:removeItemPickup', function(data)
    local _src = source

    if #(GetEntityCoords(GetPlayerPed(_src)) - data.coords) <= 5.5 then
        if Offline.Pickup[data.id] then
            if Offline.Inventory.CanCarryItem(Offline.ServerPlayers[_src], data.name, tonumber(data.count)) then
                Offline.Pickup[data.id] = nil
                Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[_src], data.name, tonumber(data.count), data.label)
                Offline.SendEventToClient('offline:interactItemPickup', -1, "retrieve", data)
            else
                Offline.SendEventToClient('offline:notify', source, '~r~Vous n\'avez plus de place.')
            end
        else
            Offline.SendEventToClient('offline:notify', source, '~r~ERREUR.')
        end
    end
end)