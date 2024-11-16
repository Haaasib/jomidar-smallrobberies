local Jomidar = exports[J0.Core]:GetCoreObject()
local CurrentCops = 0
function createTriggerInteraction(id)
    local triggerPoint = J0.clothingStoreTriggerPoint[id]

    if triggerPoint then
        if J0.Target then
            -- Using qb-target
            exports['qb-target']:AddBoxZone('trigger_' .. id, triggerPoint.triggerloc, 1.0, 1.0, {
                name = 'trigger_' .. id,
                heading = 0,
                debugPoly = false,
                minZ = triggerPoint.triggerloc.z - 1.0,
                maxZ = triggerPoint.triggerloc.z + 1.0
            }, {
                options = {
                    {
                        icon = 'fas fa-hand',
                        label = 'Interact',
                        action = function(entity, coords, args)
                            interactLogic(id)
                        end
                    }
                },
                distance = 2.0
            })
        else
            -- Using interact
            exports.interact:AddInteraction({
                coords = triggerPoint.triggerloc, -- Use the triggerloc for interaction location
                distance = 4.0,
                interactDst = 2.0,
                id = 'trigger_' .. id, -- Unique ID based on trigger point
                name = 'interaction_' .. id,
                options = {
                    {
                        label = 'Interact',
                        action = function(entity, coords, args)
                            interactLogic(id)
                        end
                    },
                }
            })
        end
    end
end

-- The logic for interaction
function interactLogic(id)
    -- Minimum police required for interaction
    local minPoliceRequired = J0.CopNeed

    -- Check if there are enough police on duty
    Jomidar.Functions.TriggerCallback('jomidar-police:getOnlinePoliceCount', function(policeCount)
        if policeCount >= minPoliceRequired then
            -- Check the time for the robbery
            Jomidar.Functions.TriggerCallback('jomidar-srobbery:sv:checkTime', function(time)
                if time then
                    -- Start the progress bar and animation
                    Jomidar.Functions.Progressbar("random_task", "You're Breaking The Machine....", 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "missheist_jewel",
                        anim = "smash_case",
                        flags = 49,
                    }, {}, {}, function()
                        TriggerServerEvent('jomidar:srobbery:addmoney', J0.MoneyReward)
                        AlertCopsPackage()
                        createShoeInteraction(id)
                    end, function()
                        -- On cancel (if necessary)
                    end)
                end
            end)
        else
            -- Notify player there are not enough police online
            Jomidar.Functions.Notify("Not enough police officers on duty.", "error")
        end
    end)
end

-- Function to create interaction at the shoeloc
function createShoeInteraction(id)
    local triggerPoint = J0.clothingStoreTriggerPoint[id]

    if triggerPoint then
        if J0.Target then
            -- Using qb-target
            exports['qb-target']:AddBoxZone('shoeloc_' .. id, triggerPoint.shoeloc, 1.0, 1.0, {
                name = 'shoeloc_' .. id,
                heading = 0,
                debugPoly = false,
                minZ = triggerPoint.shoeloc.z - 1.0,
                maxZ = triggerPoint.shoeloc.z + 1.0
            }, {
                options = {
                    {
                        icon = 'fas fa-shoe-prints',
                        label = 'Take Shoes',
                        action = function(entity, coords, args)
                            shoeLootingLogic(id)
                        end
                    }
                },
                distance = 2.0
            })
        else
            -- Using interact
            exports.interact:AddInteraction({
                coords = triggerPoint.shoeloc, -- Use the shoeloc for interaction location
                distance = 4.0,
                interactDst = 2.0,
                id = 'shoeloc_' .. id, -- Unique ID for shoeloc interaction
                name = 'Take Shoes',
                options = {
                    {
                        label = 'Take Shoes',
                        action = function(entity, coords, args)
                            shoeLootingLogic(id)
                        end
                    }
                }
            })
        end
    end
end

-- Logic for looting shoes
function shoeLootingLogic(id)
    Jomidar.Functions.Progressbar("random_task", "You're Looting....", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "missheist_jewel",
        anim = "smash_case",
        flags = 49,
    }, {}, {}, function()
        local itemadd1 = 'shoebox'
        TriggerServerEvent('jomidar:srobbery:addItem', itemadd1, 1)
        if J0.Target then
            exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
        else
            exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
        end

        Jomidar.Functions.Progressbar("random_task", "You're Looting....", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "missheist_jewel",
            anim = "smash_case",
            flags = 49,
        }, {}, {}, function()
            local itemadd1 = 'shoebox'
            TriggerServerEvent('jomidar:srobbery:addItem', itemadd1, 1)
            if J0.Target then
                exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
            else
                exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
            end
            Jomidar.Functions.Progressbar("random_task", "You're Looting....", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "missheist_jewel",
                anim = "smash_case",
                flags = 49,
            }, {}, {}, function()
                local itemadd1 = 'shoebox'
                TriggerServerEvent('jomidar:srobbery:addItem', itemadd1, 1)
                if J0.Target then
                    exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
                else
                    exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
                end
            end, function() 
                if J0.Target then
                    exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
                else
                    exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
                end
            end)
        end, function() 
            if J0.Target then
                exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
            else
                exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
            end
        end)

    end, function() 
        if J0.Target then
            exports['qb-target']:RemoveZone('shoeloc_' .. id) -- Remove qb-target interaction after completion
        else
            exports.interact:RemoveInteraction('shoeloc_' .. id) -- Remove interact interaction after completion
        end
    end)
end

-- Create interactions for all trigger points on script start
CreateThread(function()
    for id, _ in pairs(J0.clothingStoreTriggerPoint) do
        createTriggerInteraction(id) -- Create interactions for each triggerloc
    end
end)

function getRandomItemWithChance()
    local chance = math.random(1, 100) -- Generates a random number between 1 and 100
    
    if chance <= J0.ShoeSetup.ChanceRare then
        return J0.ShoeSetup.lootClothing[1]
    else
        return J0.ShoeSetup.lootClothing[2]
    end
end

RegisterNetEvent('Jomidar-srobbery:client:openBox1', function()
    Jomidar.Functions.Progressbar("RR", "Opening Shoe Box....", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = true,
        disableCombat = true,
     }, {
        animDict = "anim@amb@nightclub@djs@dixon@",
        anim = "dixn_dance_cntr_open_dix",
        flags = 49,
     }, {}, {}, function()
        TriggerServerEvent('jomidar:srobbery:removeItem', 'shoebox' , 1)
        local item = getRandomItemWithChance()
        TriggerServerEvent('jomidar:srobbery:addItem', item.name, item.amount)
     end, function()
        -- Cancel
     end)
end)

local hasShoesOn = false
local previousShoeId = 0
local previousShoeTexture = 0

RegisterNetEvent('shoebox:useItem', function()
    local playerPed = PlayerPedId()

    if hasShoesOn then
        -- Restore previous shoes
        SetPedComponentVariation(playerPed, 6, previousShoeId, previousShoeTexture, 2)
        Jomidar.Functions.Notify("You put on your previous shoes.", "success")
    else
        -- Store current shoes
        previousShoeId, previousShoeTexture = GetPedDrawableVariation(playerPed, 6), GetPedTextureVariation(playerPed, 6)
        
        -- Equip new shoes
        SetPedComponentVariation(playerPed, 6, J0.RareShoeNumber, J0.RareShoeTextureNumber, 2) -- Change `1` and `0` to the desired new shoe ID and texture
        Jomidar.Functions.Notify("You put on new shoes.", "success")
    end

    -- Toggle shoes state
    hasShoesOn = not hasShoesOn
end)

local hasShoesOn1 = false
local previousShoeId1 = 0
local previousShoeTexture1 = 0

RegisterNetEvent('shoebox:useItem1', function()
    local playerPed = PlayerPedId()

    if hasShoesOn1 then
        -- Restore previous shoes
        SetPedComponentVariation(playerPed, 6, previousShoeId1, previousShoeTexture1, 2)
        Jomidar.Functions.Notify("You put on your previous shoes.", "success")
    else
        -- Store current shoes
        previousShoeId1, previousShoeTexture1 = GetPedDrawableVariation(playerPed, 6), GetPedTextureVariation(playerPed, 6)
        
        -- Equip new shoes
        SetPedComponentVariation(playerPed, 6, J0.NormalShoeNumber, J0.NormalShoeTextureNumber, 2) -- Change `1` and `0` to the desired new shoe ID and texture
        Jomidar.Functions.Notify("You put on new shoes.", "success")
    end

    -- Toggle shoes state
    hasShoesOn1 = not hasShoesOn1
end)
