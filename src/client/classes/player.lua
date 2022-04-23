---@class _Offline_Player
---@field id number
---@field public name string
---@field public identifier string
---@field public discordId number
---@field public source number
---@field public currentZone string
---@field public inventory table
---@field public characterInfos table
---@field public coords vector3
---@field public weight number
_Offline_Player = {}

---InitPlayer
---@type function
---@param obj table
---@public
function _Offline_Player:Initplayer(obj) 
    local data = {}
    setmetatable(data, self)
    self.__index = self
    data.id = obj.id
    data.name = obj.name
    data.identifier = obj.identifier
    data.discordId = obj.discordId
    data.source = obj.source
    data.currentZone = obj.currentZone
    data.inventory = obj.inventory
    data.characterInfos = obj.characterInfos
    data.coords = obj.coords
    data.weight = obj.weight
    _Offline_Player = obj
end

_Offline_Client_.RegisterClientEvent('InitPlayer', function(data)
    _Offline_Player:Initplayer(data)
end)

_Offline_Client_.RegisterClientEvent('UpdatePlayer', function(data)
    _Offline_Player = data
end)