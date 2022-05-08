-- CONST_POPULATION_TYPE_MISSION = 7

AddEventHandler('entityCreating', function(id)    
    local entityModel = GetEntityModel(id)
    local entityType = GetEntityType(id)

    if entityType == 3 then -- Objects
        if Shared.Anticheat.WhitelistObject then
            if Shared.Anticheat.ListObjects[entityModel] then
                CancelEvent()
            end
        end
    elseif entityType == 2 then -- Vehicles
        if Shared.Anticheat.BlacklistVehicle then
            if Shared.Anticheat.ListVehicles[entityModel] then
                CancelEvent()
            end
        end
    elseif entityType == 1 then -- Peds
        if Shared.Anticheat.BlacklistPed then
            if Shared.Anticheat.ListPeds[entityModel] then
                CancelEvent()
            end
        end
    end
end)