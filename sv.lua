local Jomidar = exports[J0.Core]:GetCoreObject()
local lastHeistTime = 0 

Jomidar.Functions.CreateUseableItem("shoeboxrare", function(source, item)
    local Player = Jomidar.Functions.GetPlayer(source)
    TriggerClientEvent("shoebox:useItem", source)
end)

Jomidar.Functions.CreateUseableItem("shoeboxnormal", function(source, item)
    local Player = Jomidar.Functions.GetPlayer(source)
    TriggerClientEvent("shoebox:useItem1", source)
end)

--- Callback
Jomidar.Functions.CreateCallback('jomidar-srobbery:sv:checkTime', function(source, cb)
    local src = source
    local player = Jomidar.Functions.GetPlayer(src)
    
    local currentTime = os.time()
    local timeSinceLastHeist = currentTime - lastHeistTime
    
    if timeSinceLastHeist < J0.CoolDown and lastHeistTime ~= 0 then
        local secondsRemaining = J0.CoolDown - timeSinceLastHeist
        local minutesRemaining = math.floor(secondsRemaining / 60)
        local remainingSeconds = secondsRemaining % 60

        TriggerClientEvent('QBCore:Notify', src, "You must wait " .. minutesRemaining .. " min and " .. remainingSeconds .. " sec before starting another work.", "error")
        cb(false)
    else
        lastHeistTime = currentTime
        cb(true)
    end
end)

Jomidar.Functions.CreateCallback('jomidar-police:getOnlinePoliceCount', function(source, cb)
    local policeCount = 0
    for _, playerId in pairs(Jomidar.Functions.GetPlayers()) do
        local Player = Jomidar.Functions.GetPlayer(playerId)
        if Player and Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    cb(policeCount)
end)

-- Trigger

Jomidar.Functions.CreateUseableItem('parcel', function(source)
    TriggerClientEvent('Jomidar-srobbery:client:openBox', source)
end)

Jomidar.Functions.CreateUseableItem('shoebox', function(source)
    TriggerClientEvent('Jomidar-srobbery:client:openBox1', source)
end)

RegisterNetEvent('jomidar:srobbery:removeItem', function(item, ammount)
    local src = source
    local Player = Jomidar.Functions.GetPlayer(src)
    if Player then
    Player.Functions.RemoveItem(item, ammount)
    TriggerClientEvent('inventory:client:ItemBox', src, Jomidar.Shared.Items[item], "remove")
    end
end)

RegisterNetEvent('jomidar:srobbery:addItem', function(item, ammount)
    local src = source
    local Player = Jomidar.Functions.GetPlayer(src)
    if Player then
    Player.Functions.AddItem(item, ammount)
    TriggerClientEvent('inventory:client:ItemBox', src, Jomidar.Shared.Items[item], "add")
    end
end)

RegisterNetEvent('jomidar:srobbery:addmoney', function(amount)
    local src = source
    local Player = Jomidar.Functions.GetPlayer(src)
    if Player then
    Player.Functions.AddMoney('cash', J0.Ammount, 'jomidar-addmoney')
    TriggerClientEvent('QBCore:Notify', src, "Great Job You Got"..amount.."$", "success")
    end
end)