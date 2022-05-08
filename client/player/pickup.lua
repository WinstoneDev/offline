Offline.Pickup = {}

Offline.IsRetrieving = false

Offline.RegisterClientEvent('offline:interactItemPickup', function(type, data)
    print(type)
    print(json.encode(data))
    if type == "create" then
        object = CreateObject(data.model, data.coords.x, data.coords.y, data.coords.z - 1, false, false, false)
        SetEntityHeading(object, data.coords.w)
        SetEntityAsMissionEntity(object, true, false)
        if Config.PickupModelCollision[data.model] then
            SetEntityLodDist(object, 250)
        else
            SetEntityLodDist(object, 20)
            SetEntityCollision(object, false, false)
        end
        
        Offline.Pickup[data.id] = {
            id = data.id,
            object = object,
            name = data.name, 
            label = data.label, 
            count = data.count,
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            uniqueId = data.uniqueId,
            data = data.data,
            type = data.type
        }
    elseif type == "retrieve" then
        DeleteEntity(Offline.Pickup[data.id].object)
        Offline.Pickup[data.id] = nil
        Offline.IsRetrieving = false
    end
end)

Citizen.CreateThread(function()
    local time = 1000
    while true do
        if #Offline.Pickup == 0 then
            time = 1000
        end
        for k, v in pairs(Offline.Pickup) do
            local pPed = PlayerPedId()
            local pCoords = GetEntityCoords(pPed)
            local distance = GetDistanceBetweenCoords(pCoords, vector3(v.coords.x, v.coords.y, v.coords.z), true)

            if distance <= 3.5 then
                time = 1
                Offline.DrawText3D(v.coords.x, v.coords.y, v.coords.z - 0.7, "Appuyez sur ~b~E~s~ pour ramasser\n~y~"..v.label, 5)
                if IsControlJustPressed(0, 51) and distance < 1.5 and not IsPedInAnyVehicle(pPed, false) and IsPedOnFoot(pPed) and not IsPedCuffed(pPed) and not Offline.IsRetrieving then
                    if Offline.GetClosestPlayer(PlayerPedId(), 3.5) == nil then
                        Offline.IsRetrieving = true
                        RequestAnimDict('random@domestic')
                        while not HasAnimDictLoaded('random@domestic') do
                            Citizen.Wait(100)
                        end
                        TaskPlayAnim(pPed, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 0, 1, 0, 0, 0)
                        Wait(150)
                        Offline.SendEventToServer("offline:removeItemPickup", {
                            id = v.id,
                            object = v.object,
                            name = v.name, 
                            label = v.label, 
                            count = v.count,
                            coords = v.coords,
                            uniqueId = v.uniqueId,
                            data = v.data,
                            type = v.type
                        })
                    end
                end
            end
        end
        Wait(time)
    end
end)