local Jomidar = exports[J0.Core]:GetCoreObject()

-- Function to spawn a box at a specific index
function spawnBoxAtIndex(index)
    local parcel = J0.parcelSpawnCoords[index]
    
    -- Replace 'prop_box_ammo01a' with the desired prop name
    local propModel = `prop_cs_package_01`
    local coords = parcel.coords

    -- Request the model and spawn the prop
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(0)
    end

    -- Create the prop object
    local boxProp = CreateObject(propModel, coords.x, coords.y, coords.z, true, true, false)

    -- Set heading (rotation) and freeze position
    SetEntityHeading(boxProp, coords.w)
    FreezeEntityPosition(boxProp, true)
    PlaceObjectOnGroundProperly(boxProp)

    -- Mark as not taken and store the entity
    J0.parcelSpawnCoords[index].taken = false
    J0.parcelSpawnCoords[index].entity = boxProp

    if J0.Target then
        -- Using qb-target
        exports['qb-target']:AddBoxZone('box_interaction_'..index, coords, 1.0, 1.0, {
            name = 'box_interaction_'..index,
            heading = coords.w,
            debugPoly = false,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 1.0
        }, {
            options = {
                {
                    icon = 'fas fa-box',
                    label = 'Pickup Package',
                    action = function(entity, coords, args)
                        pickupBoxLogic(boxProp, index)
                    end
                }
            },
            distance = 2.0
        })
    else
        -- Using interact
        exports.interact:AddInteraction({
            coords = coords,
            distance = 6.0, -- Optional
            interactDst = 4.0, -- Optional
            name = 'box_interaction_' .. index, -- Unique name for each box
            id = 'box_interaction_' .. index,   -- Unique id for each box
            options = {
                {
                    label = 'Pickup Package',
                    action = function(entity, coords, args)
                        pickupBoxLogic(boxProp, index)
                    end
                }
            }
        })
    end
end

-- Logic for picking up the box and triggering the dog if canceled
function pickupBoxLogic(boxProp, index)
    if DoesEntityExist(boxProp) then
        Jomidar.Functions.Progressbar("RR", "Pickup Package...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@domestic",
            anim = "pickup_low",
            flags = 49,
        }, {}, {}, function()
            -- Success: Package picked up
            AlertCopsPackage()
            DeleteEntity(boxProp)
            local itemadd = 'parcel'
            TriggerServerEvent('jomidar:srobbery:addItem', itemadd, 1)
            J0.parcelSpawnCoords[index].taken = true -- Mark as taken

            if J0.Target then
                exports['qb-target']:RemoveZone('box_interaction_'..index)
            else
                exports.interact:RemoveInteraction('box_interaction_'..index)
            end
        end, function()
            -- Failure: Spawn the dog
            spawnGuardDog()
        end)
    end
end

-- Function to spawn a guard dog
function spawnGuardDog()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnCoords = GetEntityCoords(playerPed)                            
    local model = `a_c_rottweiler` -- Change this to your desired dog model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local dog = CreatePed(28, model, spawnCoords.x + 2, spawnCoords.y, spawnCoords.z, GetEntityHeading(playerPed), true, false)
    TaskCombatPed(dog, playerPed, 0, 16) -- Dog attacks the player if pickup is canceled
end


function getRandomItem(items)
    local itemIndex = math.random(1, #items)
    return items[itemIndex]
end

RegisterNetEvent('Jomidar-srobbery:client:openBox', function()
    Jomidar.Functions.Progressbar("RR", "Opening Package....", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
     }, {
        animDict = "anim@amb@nightclub@djs@dixon@",
        anim = "dixn_dance_cntr_open_dix",
        flags = 49,
     }, {}, {}, function()
        TriggerServerEvent('jomidar:srobbery:removeItem', 'parcel' , 1)
        local item = getRandomItem(J0.lootParcel)
        TriggerServerEvent('jomidar:srobbery:addItem', item.name, item.amount)
     end, function()
        -- Cancel
     end)
end)

-- Function to spawn all boxes
function spawnAllBoxes()
    for i = 1, #J0.parcelSpawnCoords do
        spawnBoxAtIndex(i)
    end
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        spawnAllBoxes() -- Spawn boxes on resource start
    end
end)
-- Citizen thread to check every 30 seconds if a box is taken, and respawn it
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- Wait for 30 seconds

        -- Loop through all parcels and check if any are taken
        for i, parcel in ipairs(J0.parcelSpawnCoords) do
            if parcel.taken then
                spawnBoxAtIndex(i)
            end
        end
    end
end)

local holdingParcel = false
local ParcelBox = nil

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
end

local function hasParcelChanged()
    local player = PlayerPedId()
    local hasPackage = Jomidar.Functions.HasItem('parcel')
    
    if hasPackage then
        if not holdingParcel then
            holdingParcel = true
            loadAnimDict('anim@heists@box_carry@')
            TaskPlayAnim(player, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 49, 0, 0, 0, 0)
            CarryAnimation()
            RequestModel('prop_cs_package_01')
            while not HasModelLoaded('prop_cs_package_01') do
                Wait(100)
            end
            ParcelBox = CreateObject(GetHashKey('prop_cs_package_01'), 0, 0, 0, true, true, true)
            AttachEntityToEntity(ParcelBox, player, GetPedBoneIndex(player, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 2, true)
            DisableControls()
        end
    elseif holdingParcel then
        ClearPedTasks(player)
        if ParcelBox then
            DeleteObject(ParcelBox)
            ParcelBox = nil
        end
        holdingParcel = false
    end
end

-- Continuous check for package status changes
CreateThread(function()
    while true do
        hasParcelChanged()
        Wait(1250) -- Wait for a specified amount of time before checking again
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and holdingParcel then
        ClearPedTasks(PlayerPedId())
        if ParcelBox then
            DeleteObject(ParcelBox)
            ParcelBox = nil
        end
        holdingParcel = false
    end
end)

function DisableControls()
    CreateThread(function ()
        while holdingParcel do
            DisableControlAction(0, 21, true) -- Sprinting
            DisableControlAction(0, 22, true) -- Jumping
            DisableControlAction(0, 36, true) -- Ctrl
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 47, true) -- Weapon
            DisableControlAction(0, 58, true) -- Weapon (alternative)
            DisableControlAction(0, 263, true) -- Melee (general)
            DisableControlAction(0, 264, true) -- Melee (alternative)
            DisableControlAction(0, 257, true) -- Melee (another alternative)
            DisableControlAction(0, 140, true) -- Melee (another alternative)
            DisableControlAction(0, 141, true) -- Melee (another alternative)
            DisableControlAction(0, 142, true) -- Melee (another alternative)
            DisableControlAction(0, 143, true) -- Melee (another alternative)
            Wait(1)
        end
    end)
end

function CarryAnimation()
    CreateThread(function ()
        while holdingParcel do
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end



