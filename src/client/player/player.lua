CreateThread(function()
    _Offline_Client_.SendEventToServer('registerPlayer', GetPlayerServerId(PlayerId()))
    while _Offline_Player.coords == nil do Wait(5) end
    spawnPlayer({x = _Offline_Player.coords.x, y = _Offline_Player.coords.y, z = _Offline_Player.coords.z, model = GetHashKey("u_m_m_aldinapoli"), heading = 215.0}, false, function()
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)
        SwitchTrainTrack(0, true)
        SwitchTrainTrack(3, true)
        SetTrainTrackSpawnFrequency(0, 20000) -- default: 120000
        SetRandomTrains(true)
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)
        DisplayRadar(true)
        Wait(2500)
        local getGround, zGround = GetGroundZFor_3dCoord(_Offline_Player.coords.x, _Offline_Player.coords.y, _Offline_Player.coords.z, true, 0)
        if getGround then 
            SetEntityCoordsNoOffset(PlayerPedId(), _Offline_Player.coords.x, _Offline_Player.coords.y, zGround + 1.0, 0.0, 0.0, 0.0) 
        end
    end)
end)

RegisterCommand('pos', function()
    _Offline_Config_.Development.Print(GetEntityCoords(PlayerPedId()))
    _Offline_Config_.Development.Print(GetEntityHeading(PlayerPedId()))
end)