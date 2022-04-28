---@class _Offline_Inventory_
---@field public GetAllItems function
---@field public SaveInventoryInDatabase function
---@field public LoadInventoryFromDatabase function
---@field public AddItemInInventory function
---@field public RemoveItemInInventory function
---@field public DoesItemExists function
---@field public GetInfosItem function
---@field public GetInventoryWeight function
---@field public CanCarryItem function
---@field public RenameItemLabel function
---@public
_Offline_Inventory_ = {}

---GetAllItems
---@type function
---@return table
---@public
_Offline_Inventory_.GetAllItems = function()
    local items = {}
    for key, value in pairs(_Offline_Config_.Items) do
        items[key] = value
    end
    return items
end

---SaveInventoryInDatabase
---@type function
---@param player table
---@param inventory table
---@public
_Offline_Inventory_.SaveInventoryInDatabase = function(player, inventory)
    if not player then return end
    if not inventory then return end
    MySQL.Async.execute("UPDATE `inventory` SET `inventory` = '" .. json.encode(inventory) .. "' WHERE `identifier` = @identifier", {
        ['@identifier'] = player.identifier
    }, function(rowsChanged)
        if rowsChanged ~= 0 then
            _Offline_Config_.Development.Print("Successfully saved inventory for player " .. player.name)
        else
            _Offline_Config_.Development.Print("Failed to save inventory for player " .. player.name)
        end
    end)
end

---LoadInventoryFromDatabase
---@type function
---@param player table
---@param cb function
---@return table
---@public
_Offline_Inventory_.LoadInventoryFromDatabase = function(player, cb)
    if not player then return end
    MySQL.Async.fetchAll("SELECT * FROM `inventory` WHERE `identifier` = @identifier", {
        ['@identifier'] = player.identifier
    }, function(result)
        if result[1] then
            cb(result[1].inventory)
        end
    end)
end

---DoesItemExists
---@type function
---@param item string
---@return boolean
---@public
_Offline_Inventory_.DoesItemExists = function(item)
    if not item then return false end
    if _Offline_Config_.Items[item] then
        return true
    else
        return false
    end
end

---GetInfosItem
---@type function
---@param item string
---@return table
---@public
_Offline_Inventory_.GetInfosItem = function(item)
    if not item then return end
    if _Offline_Config_.Items[item] and _Offline_Inventory_.DoesItemExists(item) then
        return _Offline_Config_.Items[item]
    else
        return nil
    end
end

---GetInventoryWeight
---@type function
---@param inventory table
---@return number
---@public
_Offline_Inventory_.GetInventoryWeight = function(inventory)
    if not inventory then return end
    local weight = 0
    for key, value in pairs(inventory) do
        weight = weight + _Offline_Config_.Items[value.name].weight * value.count
    end
    return weight
end

---CanCarryItem
---@type function
---@param player table
---@param item string
---@return boolean
---@public
_Offline_Inventory_.CanCarryItem = function(player, item, quantity)
    if not player then return end
    if not item then return end
    if not quantity then quantity = 1 end
    if not _Offline_Inventory_.DoesItemExists(item) then return end
    local weight = _Offline_Inventory_.GetInventoryWeight(player.inventory)
    local itemWeight = _Offline_Config_.Items[item].weight * quantity
    if weight + itemWeight <= _Offline_Config_.Informations["MaxWeight"] then
        return true
    else
        return false
    end
end

---AddItemInInventory
---@type function
---@param player table
---@param item string
---@param quantity number
---@return boolean
---@public
_Offline_Inventory_.AddItemInInventory = function(player, item, quantity, newlabel)
    if not player then return end
    if not item then return end
    if not quantity then return end
    local exist = false

    if _Offline_Inventory_.DoesItemExists(item) then
        if _Offline_Inventory_.CanCarryItem(player, item, quantity) then
            local inventory = player.inventory
            local Itemlabel = newlabel or _Offline_Config_.Items[item].initialName

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
            local weight = _Offline_Inventory_.GetInventoryWeight(player.inventory)
            player.weight = weight
            _Offline_Server_.SendEventToClient('UpdatePlayer', player.source, _Offline_Server_.ServerPlayers[player.source])
        end
    end
end

---RemoveInventoryItem
---@type function
---@param player table
---@param item string
---@param quantity number
---@return boolean
---@public
_Offline_Inventory_.RemoveItemInInventory = function(player, item, quantity, itemLabel)
    if not player then return end
    if not item then return end
    if not quantity then return end
    local inventory = player.inventory
    local label = itemLabel or _Offline_Config_.Items[item].initialName
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
    local weight = _Offline_Inventory_.GetInventoryWeight(player.inventory)
    player.weight = weight
    _Offline_Server_.SendEventToClient('UpdatePlayer', player.source, _Offline_Server_.ServerPlayers[player.source])
end

---RenameItemLabel
---@type function
---@param player table
---@param name string
---@param item string
---@param label string
---@param quantity number
---@return boolean
---@public
_Offline_Inventory_.RenameItemLabel = function(player, name, lastLabel, newLabel, montant)
    if not player then return end
    if not name then return end
    if not lastLabel then return end
    if not newLabel then return end
    if not montant then return end
    if lastLabel == newLabel then return end

    local inventory = player.inventory
    local exist = false
    local itemName = nil
    
    for k, v in pairs(inventory) do
        if v.name == name and v.label == lastLabel then
            if tonumber(v.count) >= tonumber(montant) then
                itemName = v.name
                v.count = v.count - montant
                if v.count <= 0 then
                    table.remove(inventory, k)
                end

                for key, value in pairs(inventory) do
                    if value.name == itemName and value.label == newLabel then
                        value.count = value.count + montant
                        exist = true
                        break
                    end
                end
            else
                print('montant invalid')
                break
            end
        end
    end
    if itemName ~= nil then
        if not exist then
            table.insert(inventory, {name = itemName, label = newLabel, count = montant})
        end
        player.inventory = inventory
        local weight = _Offline_Inventory_.GetInventoryWeight(player.inventory)
        player.weight = weight
        _Offline_Server_.SendEventToClient('UpdatePlayer', player.source, _Offline_Server_.ServerPlayers[player.source])
    end
end

----

_Offline_Server_.RegisterServerEvent('renameItemPlayer', function(name, lastLabel, newLabel, montant)
    _Offline_Inventory_.RenameItemLabel(_Offline_Server_.ServerPlayers[source], name, lastLabel, newLabel, montant)
end)

_Offline_Server_.RegisterServerEvent('removeItemPlayer', function(item, quantity, itemLabel)
    _Offline_Inventory_.RemoveItemInInventory(_Offline_Server_.ServerPlayers[source], item, quantity, itemLabel)
end)

_Offline_Server_.RegisterServerEvent('useItemPlayer', function(item)
    _Offline_Inventory_.RemoveItemInInventory(_Offline_Server_.ServerPlayers[source], item)
end)