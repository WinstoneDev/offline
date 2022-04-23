---@class _Offline_Inventory_
---@field public GetAllItems function
---@field public SaveInventoryInDatabase function
---@field public LoadInventoryFromDatabase function
---@field public AddItemInInventory function
---@field public DoesItemExists function
---@field public GetInfosItem function
---@field public GetInventoryWeight function
---@field public CanCarryItem function
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
        weight = weight + _Offline_Config_.Items[value.name].weight * value.quantity
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
_Offline_Inventory_.AddItemInInventory = function(player, item, quantity)
    if not player then return end
    if not item then return end
    if not quantity then quantity = 1 end
    local inventory = player.inventory
    local found = false
    for key, value in pairs(inventory) do
        if value.name == item then
            if _Offline_Inventory_.CanCarryItem(player, item, quantity) then
                value.quantity = value.quantity + quantity
                found = true
            else
                return false
            end
        end
    end
    local itemC = _Offline_Inventory_.GetInfosItem(item)
    if not found then
        if itemC ~= nil then
            if _Offline_Inventory_.CanCarryItem(player, item, quantity) then
                table.insert(inventory, {
                    name = item,
                    quantity = quantity,
                    label = itemC.initialName
                })
            else
                return false
            end
        else
            return false
        end
    end
    player.inventory = inventory
    local weight = _Offline_Inventory_.GetInventoryWeight(player.inventory)
    player.weight = weight
    _Offline_Server_.SendEventToClient('UpdatePlayer', player.source, _Offline_Server_.ServerPlayers[player.source])
    return true
end