Offline.Inventory = {}
Offline.Inventory.ActionItems = {}

Offline.Inventory.GetAllItems = function()
    local items = {}
    for key, value in pairs(Config.Items) do
        items[key] = value
    end
    return items
end

Offline.Inventory.DoesItemExists = function(item)
    if not item then return false end
    if Config.Items[item] then
        return true
    else
        return false
    end
end

Offline.Inventory.GetInfosItem = function(item)
    if not item then return end
    if Config.Items[item] and Offline.Inventory.DoesItemExists(item) then
        return Config.Items[item]
    else
        return nil
    end
end

Offline.Inventory.GetInventoryWeight = function(inventory)
    if not inventory then return end
    local weight = 0

    for key, value in pairs(inventory) do
        weight = weight + Config.Items[value.name].weight * value.count
    end
    return weight
end

Offline.Inventory.GetInventoryItem = function(player, item)
    if not item then return end
    local count = 0

    local inventory = player.inventory

    for key, value in pairs(inventory) do
        if value.name == item then
            count = count + value.count
        end
    end
    if count ~= 0 then
        return {count = count, label = Config.Items[item].label}
    else
        return nil
    end
end

Offline.Inventory.CanCarryItem = function(player, item, quantity)
    if not player then return end
    if not item then return end
    if not quantity then quantity = 1 end
    if not Offline.Inventory.DoesItemExists(item) then return end
    local weight = Offline.Inventory.GetInventoryWeight(player.inventory)
    local itemWeight = Config.Items[item].weight * quantity
    if math.floor(weight + itemWeight) <= Config.Informations["MaxWeight"] then
        return true
    else
        return false
    end
end

Offline.Inventory.AddItemInInventory = function(player, item, quantity, newlabel)
    if not player then return end
    if not item then return end
    if not quantity then return end
    local exist = false

    if Offline.Inventory.DoesItemExists(item) then
        if Offline.Inventory.CanCarryItem(player, item, quantity) then
            local inventory = player.inventory
            local Itemlabel = newlabel or Config.Items[item].label

            if json.encode(inventory) == "[]" then
                table.insert(inventory, {name = item, label = Itemlabel, count = quantity})
            else
                for k, v in pairs(inventory) do
                    if v.name == item and v.label == Itemlabel then
                        v.count = v.count + quantity
                        exist = true
                        break
                    end
                end

                if not exist then
                    table.insert(inventory, {name = item, label = Itemlabel, count = quantity})
                end
            end
            player.inventory = inventory
            local weight = Offline.Inventory.GetInventoryWeight(player.inventory)
            player.weight = weight
            Offline.SendEventToClient('UpdatePlayer', player.source, Offline.ServerPlayers[player.source])
        end
    end
end

Offline.Inventory.RemoveItemInInventory = function(player, item, quantity, itemLabel)
    if not player then return end
    if not item then return end
    if not quantity then return end
    local inventory = player.inventory
    local label = itemLabel or Config.Items[item].label
    local removed = false

    for k, v in pairs(inventory) do
        if v.name == item and v.label == label then
            if tonumber(v.count) >= tonumber(quantity) then
                v.count = v.count - quantity
                if v.count <= 0 then
                    table.remove(inventory, k)
                end
                removed = true
                break
            else
                break
            end
        end
    end

    if not removed then
        for k, v in pairs(inventory) do
            if v.name == item then
                if tonumber(v.count) >= tonumber(quantity) then
                    v.count = v.count - quantity
                    if v.count <= 0 then
                        table.remove(inventory, k)
                    end
                    break
                else
                    break
                end
            end
        end
    end

    player.inventory = inventory
    local weight = Offline.Inventory.GetInventoryWeight(player.inventory)
    player.weight = weight
    Offline.SendEventToClient('UpdatePlayer', player.source, Offline.ServerPlayers[player.source])
end

Offline.Inventory.RenameItemLabel = function(player, name, lastLabel, newLabel, quantity)
    if not player then return end
    if not name then return end
    if not lastLabel then return end
    if not newLabel then return end
    if not quantity then return end
    if lastLabel == newLabel then return end

    local inventory = player.inventory
    local exist = false
    local itemName = nil
    
    for k, v in pairs(inventory) do
        if v.name == name and v.label == lastLabel then
            if tonumber(v.count) >= tonumber(quantity) then
                itemName = v.name
                v.count = v.count - quantity
                if v.count <= 0 then
                    table.remove(inventory, k)
                end

                for key, value in pairs(inventory) do
                    if value.name == itemName and value.label == newLabel then
                        value.count = value.count + quantity
                        exist = true
                        break
                    end
                end
            else
                break
            end
        end
    end
    if itemName ~= nil then
        if not exist then
            table.insert(inventory, {name = itemName, label = newLabel, count = quantity})
        end
        player.inventory = inventory
        Offline.SendEventToClient('UpdatePlayer', player.source, Offline.ServerPlayers[player.source])
    end
end

Offline.RegisterUsableItem = function(item, cb)
	Offline.Inventory.ActionItems[item] = cb
end

Offline.UseItem = function(source, item, ...)
    if Offline.Inventory.ActionItems[item] then
	    Offline.Inventory.ActionItems[item](source, ...)
    end
end

Offline.RegisterUsableItem('bread', function(source, args)
    if args ~= nil then
        print('source : ('..source..')')
        print('args 1 : '..args)
        Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[source], 'bread', 1)
    end
end)

Offline.RegisterServerEvent('offline:renameItem', function(name, lastLabel, newLabel, quantity)
    Offline.Inventory.RenameItemLabel(Offline.ServerPlayers[source], name, lastLabel, newLabel, quantity)
end)

Offline.RegisterServerEvent('offline:removeItem', function(item, quantity, itemLabel)
    Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[source], item, quantity, itemLabel)
end)

Offline.RegisterServerEvent('offline:useItem', function(item, ...)
    if Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[source], item) ~= nil then
        if Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[source], item).count > 0 then
            Offline.UseItem(source, item, ...)
        end
    end
end)

Offline.RegisterServerEvent('offline:transfer', function(table)
    local source = source
    local sourcePed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(table.target)
    if #(GetEntityCoords(sourcePed)-GetEntityCoords(targetPed)) <= 7.0 then
        if Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[source], table.name) ~= nil then
            if Offline.Inventory.GetInventoryItem(Offline.ServerPlayers[source], table.name).count >= table.count then
                if Offline.Inventory.CanCarryItem(Offline.ServerPlayers[table.target], table.name, table.count) then
                    Offline.Inventory.RemoveItemInInventory(Offline.ServerPlayers[source], table.name, table.count, table.label)
                    Offline.Inventory.AddItemInInventory(Offline.ServerPlayers[table.target], table.name, table.count, table.label)
                else
                    Offline.SendEventToClient('offline:notify', table.target, '~r~Vous ne pouvez pas transporter cet objet.')
                    Offline.SendEventToClient('offline:notify', source, '~r~La personne ne peut pas transporter cet objet.')
                end
            end
        end
    else
        Offline.SendEventToClient('offline:notify', source, '~r~Il n\'y a aucune personne aux alentours de vous.')
    end
end)