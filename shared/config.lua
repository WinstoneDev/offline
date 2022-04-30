Config = {}

Config.Informations = {
    ["Version"] = "1.0.0",
    ["Name"] = "Offline V1 Whitelist",
    ["Description"] = "Serveur Roleplay Français",
    ["Discord"] = "discord.gg/offlinerp",
    ['MaxWeight'] = 45
}

Config.DiscordStatus = {
    ["ID"] = 922259908576022578,
    ["LargeIcon"] = "logo",
    ["LargeIconText"] = Config.Informations["Discord"],
    ["SmallIcon"] = "logo",
    ["SmallIconText"] = "Offline V"..Config.Informations["Version"],
}

Config.Development = {
    Debug = true,
    Print = function(message)
        if Config.Development.Debug then
            print("[Offline] " .. message)
        end
    end
}

Config.Items = {
    ['bread'] = {label = "Pain", weight = 0.01, props = "prop_sandwich_01"},
    ['water'] = {label = "Bouteille d'eau", weight = 0.01},
    ['radio'] = {label = "Radio", weight = 0.05, props = "prop_cs_hand_radio"},
}