Config = {}

Config.WebhookLink = '' --insert your webhook link here (leave empty for no webhooks)

Config.Lang = "English"

Config.Job = "petrolist" -- You can put Config.Job = false if you don't want a job requirement


Config.DisableCinematicCamera = false
------------------------------------------ Oil Job Setup ---------------------------------------------------
---------Oil Part of the job -------------
Config.OilandSupplyWagonSpawn = {x = 526.83, y = 703.01, z = 117.0, h = 263.92} --Coords your oil and supply wagons will spawn at
Config.ManagerBlip = true --If true will create a blip on the Manager, if false it will not
Config.ManagerPedModel = 'u_m_m_cktmanager_01' -- This is the model the manager will spawn as
Config.OilWagon = {price = 100, sellprice = 80} --Oil wagon model hash theres 2 but there the same(making this easily changeable incase you do want to change the model)
Config.OilWagonFillTime = 10000 --time in ms it takes to fill the oil wagon aswell as unload when delivering oil
Config.BasicOilDeliveryPay = 50 --This is the base pay rate for doing an oil mission (the payoutbonus in the Config.OilCompanyLevels will be added to this amount)
Config.LevelIncreasePerDelivery = 1 --sets the amount your level increases per delivery mission
--------------------- config player's wagon blip---------------------------
Config.OilWagonBilpHash = 1612913921 --Set Oil Wagon blip icon using blip hashes (https://redlookup.com/blips)
Config.OilWagonBlipColor = 'BLIP_MODIFIER_MP_COLOR_32' --Set Supply wagon blip color. you can find the colors you can use in the end of this config file
Config.SupplyWagonBilpHash = 1612913921 --Set Supply Wagon blip icon using blip hashes (https://redlookup.com/blips)
Config.SupplyWagonBlipColor = 'BLIP_MODIFIER_MP_COLOR_32' --Set Supply wagon blip color. you can find the colors you can use in the end of this config file
------------------------ config company manager blip and criminal blip-------------------------
Config.ManagerBlipHash = 1000514759
Config.ManagerBlipColor = 'BLIP_MODIFIER_MP_COLOR_2'
Config.CriminalBlipHash = 1000514759
Config.CriminalBlipColor = 'BLIP_MODIFIER_MP_COLOR_2'

-------------This is the levels, and what they pay-----------------------------------------
--This level setup is for the entire oil company this will effect payout for basic jobs etc(You can add or remove levels as you please but there has to be atleast 1)
Config.SniffOil = { --oil sniffing setup
    enable = true, --if true players will be able to sniff oil and get high
    Coords = {x = 485.47, y = 678.98, z = 117.31}, --coords you will have to go to to sniff oil
    EffectTime = 30000, --the time the screen effect will last
}

Config.OilCompanyLevels = {
    {
        level = 10, --this is the level you have to be at or above to get the bonus
        payoutbonus = 20, --this is how much extra you will get when finishing a delivery mission
        nextlevel = 20, --this has to be the next level so since the next level is 20 this has to be 20
    },
    {
        level = 20,
        payoutbonus = 40,
        nextlevel = 30,
    },
    {
        level = 30,
        payoutbonus = 100,
        nextlevel = 40,
    },
}

--------Place Where You Will Go To Deliver The Oil, It Picks Randomly Each Delivery--------
Config.OilDeliveryPoints = {
    {
        DeliveryPoint = {x = -223.44, y = 642.03, z = 113.14}, --the point you have to go to
        NpcSpawn = {x = -226.0, y = 632.26, z = 113.21, h = 200}, --the point the npc will spawn make this close to the deliverypoint coords
    },
    {
        DeliveryPoint = {x = -172.01, y = 652.05, z = 113.73},
        NpcSpawn = {x = -179.5, y = 650.0, z = 113.58, h = 200},
    },
}

------Supply part of the job-----------
Config.SupplyWagon = {price = 200, sellprice = 150} --price and sell price of supply wagon
Config.FillySupplyWagonTime = 10000 --time it will take to fill your supply wagon
Config.SupplyDeliveryBasePay = 70 --Base pay for delivering supplies

--These are the locations the script will randomly pick one from them to make you deliver too
Config.SupplyDeliveryLocations = {
    {x = 781.75, y = 854.34, z = 118.36},
    {x = 1100.41, y = 493.49, z = 95.63},
    {x = 891.75, y = 266.95, z = 116.3},
}

--------------Criminal Job Setup----------------------------------------------
Config.CriminalPedSpawn = {x = 1466.55, y = 802.93, z = 100.13, h = 231.88} --this is the location the criminal ped that gives you jobs will spawn
Config.CriminalPedBlip = true --if enabled this will place a blip on the criminal peds location on the map
Config.CriminalPedModel = 'g_m_m_unicriminals_01' --model of the criminal ped
Config.CriminalLevelIncrease = 1 --this is how much your level will increase per job completed(this is for all jobs)
Config.OilCompanyLevelDecrease = 1 --this is how much your oilco level will decrease upon doing a criminal misison
Config.StealOilWagonBasePay = 60 --this is the base pay for stealing an oil wagon
Config.CrimBlipHash = 'blip_mp_torch' --Blip hash
Config.RobOilWagonCooldown = 720000 --Amount of time in ms that has to pass before anyone can rob the oil wagon again
Config.RobOilCoCooldown = 120000 --Time in ms before a player can rob the oil company again

-----Level Setup-----
Config.CriminalLevels = {
    {
        level = 10, --this is the level you have to be at or above to get the bonus
        payoutbonus = 2000, --this is how much extra you will get when finishing a delivery mission
        nextlevel = 20, --this has to be the next level so since the next level is 20 this has to be 20
    },
    {
        level = 20,
        payoutbonus = 40,
        nextlevel = 30,
    },
    {
        level = 30,
        payoutbonus = 100,
        nextlevel = 40,
    },
}

----Steal Oil Wagon Setup-----
Config.OilWagonrobberyLocations = {
    {
        wagonLocation = vector3(381.15, -21.5, 109.09),
        wagonHeading = 360,
        pedlocation = {
            {x = 384.9, y = -23.37, z = 109.06},
            {x = 383.09, y = -19.78, z = 108.91},
            {x = 381.08, y = -13.82, z = 108.57},
        },
        returnlocation = {x = 1479.15, y = 804.79, z = 100.28},
    },
}

---Rob Oil Company Setup----
Config.RobOilCoEnemyPeds = false --if true enemy peds will spawn when you are done lockpicking to fight you
Config.RobOilCoEnemyPedsLocations = {
    {x = 505.34, y = 700.74, z = 116.05},
    {x = 503.61, y = 689.27, z = 117.48},
    {x = 507.35, y = 682.53, z = 117.39},
    {x = 512.52, y = 686.54, z = 117.4},
}

Config.LockPick = {
    MaxAttemptsPerLock = 3,
    lockpickitem = 'lockpick',
    difficulty = 10,
    hintdelay = 500,
}

Config.RobOilCompany = {
    {
        lootlocation = {x = 493.83, y = 675.16, z = 117.39}, --locations where you will have to go to lockpick
        rewards = { --this will handle the rewards
            itemspayout = true, --if true it will give items, if false it will just pay the cash amount set below
            cashpayout = 100, --this is the amount of cash it will give you
            items = { --this will handle the items
                {
                    item = 'leggbears', --name of the item in DB
                    count = 2, --count you want it too give
                },
                {
                    item = 'meat',
                    count = 1,
                }, --you can set more items use this as an example to add more
            },
        },
    }, --you can add more locations to this, the script will randomly choose one table each robbery too add more just copy paste table change what you need
}


local isServer = IsDuplicityVersion()

function Notify(source, text, type) -- Type can be fail, success, info
   
    local VORPcore = exports.vorp_core:GetCore()

    if isServer then
        VORPcore.NotifyRightTip(source, text, 4000)
    else
        VORPcore.NotifyRightTip(text, 4000)
    end
    
end


--[[--------BLIP_COLORS----------
LIGHT_BLUE    = 'BLIP_MODIFIER_MP_COLOR_1',
DARK_RED      = 'BLIP_MODIFIER_MP_COLOR_2',
PURPLE        = 'BLIP_MODIFIER_MP_COLOR_3',
ORANGE        = 'BLIP_MODIFIER_MP_COLOR_4',
TEAL          = 'BLIP_MODIFIER_MP_COLOR_5',
LIGHT_YELLOW  = 'BLIP_MODIFIER_MP_COLOR_6',
PINK          = 'BLIP_MODIFIER_MP_COLOR_7',
GREEN         = 'BLIP_MODIFIER_MP_COLOR_8',
DARK_TEAL     = 'BLIP_MODIFIER_MP_COLOR_9',
RED           = 'BLIP_MODIFIER_MP_COLOR_10',
LIGHT_GREEN   = 'BLIP_MODIFIER_MP_COLOR_11',
TEAL2         = 'BLIP_MODIFIER_MP_COLOR_12',
BLUE          = 'BLIP_MODIFIER_MP_COLOR_13',
DARK_PUPLE    = 'BLIP_MODIFIER_MP_COLOR_14',
DARK_PINK     = 'BLIP_MODIFIER_MP_COLOR_15',
DARK_DARK_RED = 'BLIP_MODIFIER_MP_COLOR_16',
GRAY          = 'BLIP_MODIFIER_MP_COLOR_17',
PINKISH       = 'BLIP_MODIFIER_MP_COLOR_18',
YELLOW_GREEN  = 'BLIP_MODIFIER_MP_COLOR_19',
DARK_GREEN    = 'BLIP_MODIFIER_MP_COLOR_20',
BRIGHT_BLUE   = 'BLIP_MODIFIER_MP_COLOR_21',
BRIGHT_PURPLE = 'BLIP_MODIFIER_MP_COLOR_22',
YELLOW_ORANGE = 'BLIP_MODIFIER_MP_COLOR_23',
BLUE2         = 'BLIP_MODIFIER_MP_COLOR_24',
TEAL3         = 'BLIP_MODIFIER_MP_COLOR_25',
TAN           = 'BLIP_MODIFIER_MP_COLOR_26',
OFF_WHITE     = 'BLIP_MODIFIER_MP_COLOR_27',
LIGHT_YELLOW2 = 'BLIP_MODIFIER_MP_COLOR_28',
LIGHT_PINK    = 'BLIP_MODIFIER_MP_COLOR_29',
LIGHT_RED     = 'BLIP_MODIFIER_MP_COLOR_30',
LIGHT_YELLOW3 = 'BLIP_MODIFIER_MP_COLOR_31',
WHITE         = 'BLIP_MODIFIER_MP_COLOR_32']]


----------------------------Oil Mission Tables----------------------
OilWagonTable = {} --creates the table
OilWagonTable.ManagerSpawn = {x = 498.05, y = 672.98, z = 121.04, h = 73.92} --This is where the manager npc will spawn(Do not change!!)
OilWagonTable.WagonSpawnCoords = Config.OilandSupplyWagonSpawn --this is the x y z and heaing where the wagons will spawn

--This is the table that the initial wagon fill spot will be
OilWagonTable.FillPoints = {
  {
    fillpoint = {x = 589.99, y = 635.94, z = 112.96},
    objectspawn = {x = 595.82, y = 628.48, z = 110.81},
  },
  {
    fillpoint = {x = 480.53, y = 701.24, z = 116.32},
    objectspawn = {x = 478.51, y = 693.82, z = 116.16},
  },
  {
    fillpoint = {x = 546.13, y = 578.9, z = 111.07},
    objectspawn = {x = 553.94, y = 579.91, z = 111.15},
  },
}


-----------------Tables-------------------------------
SupplyMission = {}

--THis is the table that will be used for setting the pickup / filling wagon part of the mission the script will randomly choose one of the locations set
SupplyMission.SupplyMisisonPickupLocation = {
    {
        location = {x = 505.56, y = 710.05, z = 116.39}, --pickup coords
    },
    {
        location = {x = 492.16, y = 706.42, z = 117.36},
    },
    {
        location = {x = 474.7, y = 696.03, z = 116.12},
    },
}
