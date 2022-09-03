ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('xBracelet:check')
AddEventHandler('xBracelet:check', function(pPos, name)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local xPlayers = ESX.GetPlayers()

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT bracelet FROM users WHERE identifier = '"..identifier.."'", {}, function(result)
        if (result) then
            for k,v in pairs(result) do
                if (v.bracelet) == 1 then
                    for i = 1, #xPlayers, 1 do
                        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                        if (xPlayer.getJob().name) == 'police' then TriggerClientEvent('xBracelet:blips', xPlayers[i], pPos, name) end
                    end 
                end
            end
        end
    end)
end)

RegisterNetEvent('xBracelet:addbracelet')
AddEventHandler('xBracelet:addbracelet', function(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    local identifier = xPlayer.getIdentifier()
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName()

    if (not xPlayer) then return end
    MySQL.Async.execute("UPDATE users SET bracelet = 1 WHERE identifier = '"..identifier.."'", {}, function()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if (xPlayer.getJob().name) == 'police' then TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Central", "Information", ("Initialisation du bracelet de : ~r~%s~s~"):format(name), "CHAR_CHAT_CALL", 2) end
        end 
    end)
end)

RegisterNetEvent('xBracelet:deletebracelet')
AddEventHandler('xBracelet:deletebracelet', function(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    local identifier = xPlayer.getIdentifier()
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName()

    if (not xPlayer) then return end
    MySQL.Async.execute("UPDATE users SET bracelet = 0 WHERE identifier = '"..identifier.."'", {}, function()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if (xPlayer.getJob().name) == 'police' then TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Central", "Information", ("Suppression du bracelet de : ~r~%s~s~"):format(name), "CHAR_CHAT_CALL", 2) end
        end 
    end)
end)

--

ESX.RegisterUsableItem('pince', function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName()
    local casse = math.random(1, 2)

    MySQL.Async.fetchAll("SELECT bracelet FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(result)
        for _,v in pairs(result) do
            if v.bracelet == 1 then
                MySQL.Async.execute("UPDATE users SET bracelet = 0 WHERE identifier = '"..identifier.."'", {}, function()end)
                if casse == 1 then 
                    xPlayer.removeInventoryItem("pince", 1)
                    TriggerClientEvent('esx:showNotification', source, 'Merde, la pince s\'est cassée !')
                end
                for i = 1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    if (xPlayer.getJob().name) == 'police' then TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Central", "Information", ("Signal perdu du bracelet de : ~r~%s~s~"):format(name), "CHAR_CHAT_CALL", 2) end
                end 
            else
                TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas de ~r~bracelet sur vous~s~.')
            end
        end
    end)
end)

--- Xed#1188
