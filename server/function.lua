---@class Offline
Offline = {}
Offline.Math = {}
Offline.Event = {}
Offline.Resource = {}
Offline.Token = {}
Offline.addTokenClient = {}
Offline.PlayersLimit = {}
Offline.RateLimit = {
    ['AdminServerPlayers'] = 15,
    ['MessageAdmin'] = 5,
    ['TeleportPlayers'] = 15,
    ['SetBucket'] = 10,
    ['offline:saveskin'] = 50,
    ['SetIdentity'] = 10,
    ['zones:haveInteract'] = 5,
    ['offline:renameItem'] = 5,
    ['offline:useItem'] = 20,
    ['offline:transfer'] = 20,
    ['offline:addItemPickup'] = 10,
    ['offline:removeItemPickup'] = 20,
    ['offline:haveExitedZone'] = 20,
    ['offline:GetBankAccounts'] = 20,
    ['offline:BankCreateAccount'] = 5,
    ['offline:AddClothesInInventory'] = 10,
    ['offline:BankChangeAccountStatus'] = 10,
    ['offline:BankDeleteAccount'] = 10,
    ['offline:BankCreateCard'] = 10,
    ['offline:BankwithdrawMoney'] = 10,
    ['offline:BankAddMoney'] = 10,
    ['offline:attemptToPayMenu'] = 10,
    ['offline:pay'] = 10
}

Citizen.CreateThread(function()
    while true do 
        Wait(10000)
        Offline.PlayersLimit = {}
    end
end)

---GetPlayerFromId
---@type function
---@param id number
---@return table
---@public
Offline.GetPlayerFromId = function(id)
    if not id then return end
    if Offline.ServerPlayers[id] then
        return Offline.ServerPlayers[id]
    else
        return nil
    end
end

---GetPlayerFromIdentifier
---@type function
---@param identifier string
---@return table
---@public
Offline.GetPlayerFromIdentifier = function(identifier)
    if not identifier then return end
    for key, value in pairs(Offline.ServerPlayers) do
        if v.identifier == identifier then
            break
            return value
        end
    end
end

---GeneratorToken
---@type function
---@param _source number
---@return string
---@public
Offline.GeneratorToken = function(_source)
	local token = ""

	for i = 1, 150 do
		token = token .. string.char(math.random(97, 122))
	end
    if Offline.Token[_source][token] then
        Offline.GeneratorToken(_source)
    else
        return token
    end
end

---GeneratorTokenConnecting
---@type function
---@param _source number
---@return any
---@public
Offline.GeneratorTokenConnecting = function(_source)
    if not Offline.addTokenClient[_source] then
        Offline.addTokenClient[_source] = _source

        Offline.Resource[_source] = {}
        Offline.Token[_source] = {}

        for i = 0, GetNumResources(), 1 do
            local resourceName = GetResourceByFindIndex(i)
    
            if resourceName then
                token = Offline.GeneratorToken(_source)
                Offline.Resource[_source][resourceName] = token
                Offline.Token[_source][token] = resourceName
            end
        end

        Offline.SendEventToClient("offline:addTokenEvent", _source, Offline.Resource[_source])
    else
        DropPlayer(_source, 'Injector detected ╭∩╮（︶_︶）╭∩╮')
    end
end

---GeneratorNewToken
---@type function
---@param _source number
---@param resourceName string
---@param lastToken string
---@return any
---@public
Offline.GeneratorNewToken = function(_source, resourceName, lastToken)
    token = Offline.GeneratorToken(_source)

    Offline.Token[_source][lastToken] = nil
    Offline.Resource[_source][resourceName] = token
    Offline.Token[_source][token] = resourceName
    Offline.SendEventToClient("offline:addTokenEvent", _source, Offline.Resource[_source])
end

---RegisterServerEvent
---@type function
---@param eventName string
---@param cb function
---@return nil
---@public
Offline.RegisterServerEvent = function(eventName, cb)
    if not Offline.Event[eventName] then
	    Offline.Event[eventName] = cb
        Config.Development.Print("Successfully registered event " .. eventName)
    else
        return Config.Development.Print("Event " .. eventName .. " already registered")
    end
end

---UseServerEvent
---@type function
---@param eventName string
---@param src number
---@param ... any
---@return any
---@public
Offline.UseServerEvent = function(eventName, src, ...)
    if Offline.Event[eventName] then
        if eventName ~= "offline:updateNumberPlayer" and eventName ~= "DropInjectorDetected" then
            if not Offline.PlayersLimit[eventName] then
                Offline.PlayersLimit[eventName] = {}
            end
            if not Offline.PlayersLimit[eventName][src] then
                Offline.PlayersLimit[eventName][src] = 1
            end
            Offline.PlayersLimit[eventName][src] = Offline.PlayersLimit[eventName][src] + 1
            if Offline.PlayersLimit[eventName][src] >= Offline.RateLimit[eventName] then
                --DropPlayer(src, 'Spam trigger detected ╭∩╮（︶_︶）╭∩╮ ('..eventName..')')
            else
                Offline.Event[eventName](...)
            end
        else
            Offline.Event[eventName](...)
        end
    end
end

RegisterNetEvent("offline:useEvent")
AddEventHandler("offline:useEvent", function(eventName, tokenResource, ...)
    local _src = source

    if eventName and tokenResource and Offline.Token[_src][tokenResource] then
        Offline.GeneratorNewToken(_src, Offline.Token[_src][tokenResource], tokenResource)
        Offline.UseServerEvent(eventName, _src, ...)
        Config.Development.Print("Successfully triggered server event " .. eventName)
    else
        print('Injector detected - offline:useEvent : '.._src)
        DropPlayer(_src, 'Injector detected ╭∩╮（︶_︶）╭∩╮')
        Config.Development.Print("Injector detected ╭∩╮（︶_︶）╭∩╮ " .. eventName)
    end
end)

---TriggerLocalEvent
---@type function
---@param name string
---@param ... any
---@return any
---@public
Offline.TriggerLocalEvent = function(name, ...)
    local _source = source
    if not name then return end
    TriggerEvent(name, ...)
    Config.Development.Print("Successfully triggered event " .. name .. "from source ".. _source)
end

---SendEventToClient
---@type function
---@param name string
---@param receiver number
---@param ... any
---@return any
---@public
Offline.SendEventToClient = function(name, receiver, ...)
    if not name then return end
    if not receiver then return end 

    TriggerClientEvent(name, receiver, ...)
    Config.Development.Print("Successfully sent event " .. name .. " to client ".. receiver)
end

---AddEventHandler
---@type function
---@param name string
---@param execute function
---@return any
---@public
Offline.AddEventHandler = function(name, execute)
    if not name then return end
    if not execute then return end
    AddEventHandler(name, function(...)
        execute(...)
    end)
    Config.Development.Print("Successfully added event " .. name)
end

---GetEntityCoords
---@type function
---@param entity number
---@return table
---@public
Offline.GetEntityCoords = function(entity)
    if not entity then return end
    local _entity = GetEntityCoords(GetPlayerPed(entity))
    return vector3(_entity.x, _entity.y, _entity.z)
end

Offline.RegisterServerEvent('offline:updateNumberPlayer', function()
    local _source = source
    local number = 0
    for key, value in pairs(Offline.ServerPlayers) do
        number = number + 1
    end
    Offline.SendEventToClient('offline:receiveNumberPlayers', _source, number)
end)

Offline.RegisterServerEvent('DropInjectorDetected', function()
    local _src = source
    DropPlayer(_src, 'Injector detected ╭∩╮（︶_︶）╭∩╮')
end)

---Round
---@type function
---@param value number
---@param numDecimalPlaces number
---@return number
---@public
Offline.Math.Round = function(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

---ConverToBoolean
---@type function
---@param number number
---@return boolean
---@public
Offline.ConverToBoolean = function(number)
    if number == 0 then
        return false
    elseif number == 1 then
        return true
    end
end

---ConverToNumber
---@type function
---@param boolean boolean
---@return number
---@public
Offline.ConverToNumber = function(boolean)
    if boolean == false then
        return 0
    elseif boolean == true then
        return 1
    end
end

---SpawnPed
---@type function
---@param hash string
---@param coords table
---@param anim number
---@return void
---@public
Offline.SpawnPed = function(hash, coords, anim)
    local ped = CreatePed(4, hash, coords, false, false)
    FreezeEntityPosition(ped, true) 
    return ped
end

---stringsplit
---@type function
---@param string string
---@param sep string
---@return table
---@public
Offline.StringSplit = function(string, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {} ; i = 1
    for str in string.gmatch(string, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end