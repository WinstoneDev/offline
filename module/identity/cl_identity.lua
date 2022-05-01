Offline.RegisterClientEvent('offline:useIdCard', function(data)
    Offline.ShowNotification('Prénom : '..data.Prenom..'\nNom : '..data.NDF..'\nDate de naissance : '..data.DDN..'\nLieu de naissance : '..data.LDN..'\nTaille : '..data.Taille..'cm')
end)