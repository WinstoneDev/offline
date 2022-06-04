---@class Offline.Money
Offline.Money = {}

---GetPlayerMoney
---@type function
---@param player table
---@return number
---@public
Offline.Money.GetPlayerMoney = function(player)
    if player ~= nil then
        return player.cash
    end
end

---GetPlayerDirtyMoney
---@type function
---@param player table
---@return number
---@public
Offline.Money.GetPlayerDirtyMoney = function(player)
    if player ~= nil then
        return player.dirty
    end
end

---SetPlayerMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.SetPlayerMoney = function(player, amount)
    if player ~= nil then
        player.cash = amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

---AddPlayerMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.AddPlayerMoney = function(player, amount)
    if player ~= nil then
        player.cash = player.cash + amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

---RemovePlayerMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.RemovePlayerMoney = function(player, amount)
    if player ~= nil then
        if player.cash >= tonumber(amount) then
            player.cash = player.cash - amount
            Offline.SendEventToClient('UpdatePlayer', player.source, player)
        end
    end
end

---SetPlayerDirtyMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.SetPlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        player.dirty = amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

---AddPlayerDirtyMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.AddPlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        player.dirty = player.dirty + amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

---RemovePlayerDirtyMoney
---@type function
---@param player table
---@param amount number
---@return any
---@public
Offline.Money.RemovePlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        if player.dirty >= tonumber(amount) then
            player.dirty = player.dirty - amount
            Offline.SendEventToClient('UpdatePlayer', player.source, player)
        end
    end
end