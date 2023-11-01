ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

--

RegisterNetEvent('xBracelet:blips')
AddEventHandler('xBracelet:blips', function(pPos, name)
    local blipId = AddBlipForCoord(pPos.x, pPos.y, pPos.z)
    SetBlipSprite(blipId, 148)
    SetBlipScale(blipId, 1.5)
    SetBlipColour(blipId, 13)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(("Bracelet de: %s"):format(name))
    EndTextCommandSetBlipName(blipId)
    Wait(4000)
    RemoveBlip(blipId)
end)


local open = false
local mainMenu = RageUI.CreateMenu("Bracelet", "Interaction", nil, nil, "root_cause5", "img_bleu")
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function MenuBracelet()
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    local target, dst = ESX.Game.GetClosestPlayer()
                    if target ~= -1 and dst <= 1.5 then
                        RageUI.Button("Mettre un bracelet", nil, {RightLabel = "→"}, true, {
                            onSelected = function() TriggerServerEvent('xBracelet:addbracelet', GetPlayerServerId(target)) end
                        })
                        RageUI.Button("Retirer un bracelet", nil, {RightLabel = "→"}, true, {
                            onSelected = function() TriggerServerEvent('xBracelet:deletebracelet', GetPlayerServerId(target)) end
                        })
                    else
                        RageUI.Button("~r~→~s~ Personne à proximité !", nil, {RightLabel = ""}, true, {})
                    end
                end)
            end
        end)
    end    
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000

        if ESX.PlayerData.job.name == "police" then
            local pos = Config.Position.AddBracelet
            local pPos = GetEntityCoords(PlayerPedId())
            local dst = Vdist(pPos.x, pPos.y, pPos.z, pos.x, pos.y, pos.z)

            if dst <= 3.0 then
                wait = 0
                DrawMarker(21, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0, 200, 0, true, p19, 0)
            end

            if dst <= 2.0 then
                wait = 0
                if not open then ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour mettre un bracelet électronique.") end
                if IsControlJustPressed(1, 51) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    MenuBracelet()
                end
            end
            end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pPos = GetEntityCoords(PlayerPedId())
        local name = GetPlayerName(PlayerId())
        TriggerServerEvent('xBracelet:check', pPos, name)
        Citizen.Wait(5000)
    end
end)


--- Xed#1188
