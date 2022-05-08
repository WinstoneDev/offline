Offline.Money = {}

Offline.Money.GetPlayerMoney = function(player)
    if player ~= nil then
        return player.cash
    end
end

Offline.Money.GetPlayerDirtyMoney = function(player)
    if player ~= nil then
        return player.dirty
    end
end

Offline.Money.SetPlayerMoney = function(player, amount)
    if player ~= nil then
        player.cash = amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

Offline.Money.AddPlayerMoney = function(player, amount)
    if player ~= nil then
        player.cash = player.cash + amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

Offline.Money.RemovePlayerMoney = function(player, amount)
    if player ~= nil then
        if player.cash >= tonumber(amount) then
            player.cash = player.cash - amount
            Offline.SendEventToClient('UpdatePlayer', player.source, player)
        end
    end
end

Offline.Money.SetPlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        player.dirty = amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

Offline.Money.AddPlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        player.dirty = player.dirty + amount
        Offline.SendEventToClient('UpdatePlayer', player.source, player)
    end
end

Offline.Money.RemovePlayerDirtyMoney = function(player, amount)
    if player ~= nil then
        if player.dirty >= tonumber(amount) then
            player.dirty = player.dirty - amount
            Offline.SendEventToClient('UpdatePlayer', player.source, player)
        end
    end
end