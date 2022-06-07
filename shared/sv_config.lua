---@class Shared
Shared = {}

Shared.Anticheat = {
    BlacklistVehicle = true,
    WhitelistObject = true,
    BlacklistPed = true,

    BansTypes = {
        SPAM_TRIGGER = "Vous avez été ban pour avoir spammé un trigger",
        INJECTION = "Vous avez été ban pour avoir injecté"
    },

    ListVehicles = {
        [GetHashKey('tug')] = true,
        [GetHashKey('jet')] = true,
        [GetHashKey('oppressor')] = true,
        [GetHashKey('oppressor2')] = true,
        [GetHashKey('rhino')] = true
    },

    ListPeds = {
        [""] = true,
    },

    ListObjects = {
        [""] = true,
    },

    ListExplosions = {
        [1] = true, 
        [2] = true, 
        [4] = true, 
        [5] = true, 
        [25] = true, 
        [32] = true, 
        [33] = true, 
        [35] = true, 
        [36] = true, 
        [37] = true, 
        [38] = true,

        [7] = true,
        [9] = true,
    }
}