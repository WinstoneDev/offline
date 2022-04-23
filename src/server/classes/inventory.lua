---@class _Offline_Inventory_
---@field public GetAllItems function
---@field public SaveInventoryInDatabase function
---@field public LoadInventoryFromDatabase function
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
---@return table
---@public
_Offline_Inventory_.LoadInventoryFromDatabase = function(player)
    if not player then return end
    MySQL.Async.fetchAll("SELECT * FROM `inventory` WHERE `identifier` = @identifier", {
        ['@identifier'] = player.identifier
    }, function(result)
        if result[1] then
            return json.decode(result[1].inventory)
        end
    end)
end