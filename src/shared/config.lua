---@class _Offline_Config_
---@field public Informations table
---@field public DiscordStatus table
---@field public Development table
---@field public EventsAllowedForAllPlayers table
---@field public CheckIfEventIsAllowedForAllPlayers function
---@field public Items table
---@public
_Offline_Config_ = {}

---@type table
---@public
_Offline_Config_.EventsAllowedForAllPlayers = {
    ['zones:registerBlips'] = true,
    ['zones:enteredZone'] = false,
    ['InitPlayer'] = false,
    ['UpdatePlayer'] = false
}

---CheckIfEventIsAllowedForAllPlayers
---@param event string
---@public
_Offline_Config_.CheckIfEventIsAllowedForAllPlayers = function(event)
    if _Offline_Config_.EventsAllowedForAllPlayers[event] then
        return true
    else
        return false
    end
end

---@type table
---@public
_Offline_Config_.Informations = {
    ["Version"] = "1.0.0",
    ["Name"] = "Made in France",
    ["Description"] = "Serveur Roleplay Français",
    ["Discord"] = "https://discord.gg/Pvut2WvR"
}

---@type table
---@public
_Offline_Config_.DiscordStatus = {
    ["ID"] = 964945522538455080,
    ["Name"] = "Made in France",
    ["LargeIcon"] = "logo_discord",
    ["LargeIconText"] = _Offline_Config_.Informations["Discord"],
    ["SmallIcon"] = "logo_discord",
    ["SmallIconText"] = _Offline_Config_.Informations["Name"].." ".._Offline_Config_.Informations["Version"],
    buttons = {
        [1] = {
            Name = "Discord",
            Action = _Offline_Config_.Informations["Discord"]
        },
        [2] = {
            Name = "Se connecter",
            Action = "fivem://connect/play.gtamif.fr"
        }
    }
}

---@type table
---@public
_Offline_Config_.Development = {
    Debug = true,
    Print = function(message)
        if _Offline_Config_.Development.Debug then
            print("[Offline] " .. message)
        end
    end
}

---@type table
---@public
_Offline_Config_.Items = {
    ['bread'] = {
        initialName = "Pain",
        description = "Un pain",
        usage = function()
            _Offline_Client_.SendEventToServer('player:useItem', 'bread')
        end,
        icon = "bread",
        type = 'food'
    }
}


---Test