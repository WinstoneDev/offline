Config = {}
Config.Informations = {
    ["Version"] = "1.0.0",
    ["Name"] = "Offline V1 Whitelist",
    ["Description"] = "Serveur Roleplay Français",
    ["Discord"] = "discord.gg/offlinerp",
    ['MaxWeight'] = 45,
    ['StartMoney'] = {cash = 1500, dirty = 0},
}

Config.DiscordStatus = {
    ["ID"] = 922259908576022578,
    ["LargeIcon"] = "logo",
    ["LargeIconText"] = Config.Informations["Discord"],
    ["SmallIcon"] = "logo",
    ["SmallIconText"] = "Offline V"..Config.Informations["Version"],
}

Config.Development = {
    Debug = false,
    Print = function(message)
        if Config.Development.Debug then
            print("[Offline] " .. message)
        end
    end
}

Config.Items = {
    ['bread'] = {label = "Pain", weight = 0.01, props = "prop_sandwich_01"},
    ['burger'] = {label = "Hamburger", weight = 0.02, props = "prop_sandwich_01"},
    ['water'] = {label = "Bouteille d'eau", weight = 0.01, props = "prop_ld_flow_bottle"},
    ['sprunk'] = {label = "Sprunk", weight = 0.01, props = "prop_ld_can_01"},
    ['radio'] = {label = "Radio", weight = 0.05, props = "prop_cs_hand_radio"},
    ['phone'] = {label = "Téléphone", weight = 0.01, props = "prop_phone_ing"},
    ['weapon_pistol'] = {label = "Beretta", weight = 1, props = "w_pi_pistol"},
    ['weapon_combatpistol'] = {label = "Glock-17", weight = 1, props = "w_pi_combatpistol"},
    ['idcard'] = {label = "Carte d'identité", weight = 0.005, props = "ch_prop_swipe_card_01c"},
    ['tshirt'] = {label = "Haut", weight = 0.005, props = "prop_ld_tshirt_01"},
    ['pants'] = {label = "Pantalon", weight = 0.005, props = "prop_cs_box_clothes"},
    ['shoes'] = {label = "Chaussure", weight = 0.005, props = "prop_ld_shoe_01"},
    ['helmet'] = {label = "Chapeau", weight = 0.005, props = "prop_cs_box_clothes"},
    ['glasses'] = {label = "Lunette", weight = 0.005, props = "prop_cs_sol_glasses"},
    ['chain'] = {label = "Chaine", weight = 0.005, props = "prop_cs_box_clothes"},
}

Config.InsertItems = {
    ['phone'] = true,
    ['weapon_pistol'] = true,
    ['weapon_combatpistol'] = true,
    
    ['tshirt'] = true,
    ['pants'] = true,
    ['shoes'] = true,
    ['helmet'] = true,
    ['glasses'] = true,
    ['chain'] = true,
}

Config.ResourcesClientEvent = {
    ['chat'] = true,
    ['ipl'] = true,
    ['mysql-async'] = true,
    ['offline'] = true
}

Config.PickupModelCollision = {
	["p_ld_stinger_s"] = true,
	["prop_barrier_work05"] = true,
	["prop_mp_cone_02"] = true
}