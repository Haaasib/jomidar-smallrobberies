J0 = {}

J0.Core = "qb-core"

J0.Target = true

AlertCopsPackage = function()
    exports['ps-dispatch']:SuspiciousActivity()
end
   
---------------------------------/////////////Parcel Theft\\\\\\\\\\\\\\\\------------------------------

J0.parcelSpawnCoords = {
    { coords = vector3(331.28, 465.98, 150.19), taken = false, entity = nil },
    { coords = vector3(315.78, 501.34, 151.18), taken = false, entity = nil },
    { coords = vector3(325.79, 537.41, 152.86), taken = false, entity = nil },
    { coords = vector3(317.92, 562.42, 153.54), taken = false, entity = nil },
    { coords = vector3(223.44, 514.07, 139.77), taken = false, entity = nil }
}

J0.lootParcel = { --- after opening parcel what player will get
    { name = "phone", amount = 1 },
    { name = "sandwich", amount = 1 },
}

---------------------------------/////////////Clothing Store\\\\\\\\\\\\\\\\------------------------------

J0.CoolDown = 3600

J0.CopNeed = 0

J0.MoneyReward = 1000

J0.clothingStoreTriggerPoint = {
    [1] = { triggerloc = vector3(426.39, -807.24, 29.77), shoeloc = vector3(431.47, -802.01, 29.49) },
    [2] = { triggerloc = vector3(127.47, -222.72, 53.56), shoeloc = vector3(119.01, -222.32, 54.56) },
    [3] = { triggerloc = vector3(-709.15, -151.44, 36.42), shoeloc = vector3(-717.0, -153.41, 37.42) }
}

J0.ShoeSetup = {
    lootClothing = { 
        [1] = {name = 'shoeboxrare', amount = 1},  -- Rare item
        [2] = {name = 'shoeboxnormal', amount = 1}, -- Normal item
    },
    ChanceRare = 10 -- 10% chance for rare item
}

J0.RareShoeNumber = 20  --- put the shoe number when player use it they will wear it
J0.RareShoeTextureNumber = 0 --- put the shoe texture when player use it they will wear it
J0.NormalShoeNumber = 124 --- put the shoe number when player use it they will wear it
J0.NormalShoeTextureNumber = 2 --- put the shoe texture when player use it they will wear it