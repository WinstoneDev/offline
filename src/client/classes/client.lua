---@class _Offline_Client_
---@field public RegisteredClientEvents table
---@field public TriggerLocalEvent function
---@field public RegisterClientEvent function
---@field public AddEventHandler function
---@field public SendEventToServer function
---@field public AddBlip function
---@field public DrawMarker function
---@field public SetCoords function
---@field public KeyboardInput function
---
---@public
_Offline_Client_ = {}

---@type table
---@public
_Offline_Client_.RegisteredClientEvents = {}

---TriggerLocalEvent
---@type function
---@param name string
---@param ... any
---@public
_Offline_Client_.TriggerLocalEvent = function(name, ...)
    if not name then return end
    TriggerEvent(name, ...)
    _Offline_Config_.Development.Print("Successfully triggered event " .. name)
end

---RegisterClientEvent
---@type function
---@param name string
---@param execute function
---@public
_Offline_Client_.RegisterClientEvent = function(name, execute)
    if not name then return end
    if not _Offline_Client_.RegisteredClientEvents[name] then
        RegisterNetEvent(name)
        AddEventHandler(name, function(...)
            execute(...)
        end)
        _Offline_Config_.Development.Print("Successfully registered event " .. name)
        _Offline_Client_.RegisteredClientEvents[name] = execute
    else
        return _Offline_Client_.Development.Print("Event " .. name .. " already registered")
    end
end

---AddEventHandler
---@type function
---@param name string
---@param execute function
---@public
_Offline_Client_.AddEventHandler = function(name, execute)
    if not name then return end
    if not execute then return end
    AddEventHandler(name, function(...)
        execute(...)
    end)
    _Offline_Config_.Development.Print("Successfully added event " .. name)
end


---SendToServerEvent
---@type function
---@param name string
---@param ... any
---@public
_Offline_Client_.SendEventToServer = function(name, ...)
    if not name then return end
    TriggerServerEvent(name, ...)
    _Offline_Config_.Development.Print("Successfully triggered server event " .. name)
end

---KeyboardInput
---@type function
---@param title string
---@param maxLength number
---@public
_Offline_Client_.KeyboardInput = function(title, maxLength)
    if not title then return end
    if not maxLength then return end
    AddTextEntry("Message", title)
    DisplayOnscreenKeyboard(1, "Message", '', '', '', '', '', maxLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end