Config = {}

Config.WebhookLink = '' --insert your webhook link here (leave empty for no webhooks)

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
        wagonlocation = {x = 380.75, y = -13.83, z = 108.57, h = 359.53},
        pedlocation = {
            {x = 383.81, y = -13.83, z = 108.5},
            {x = 383.94, y = -11.17, z = 108.29},
            {x = 382.98, y = -7.21, z = 107.84},
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


---------------------------------- Translate Here! ---------------------------------------------
Config.Language = {
    ManagerBlip = 'Oil Company Manager', --Manager Blip name
    ManagerDrawText = 'Company Manager press "G" to open menu',
    OilManagerMainMenuName = 'Oil Company',
    BuyWagonMenuName = 'Buy Oil Wagon?',
    OilWagonBought = 'You purchased an Oil Wagon!',
    OilWagonAlreadyBought = 'You already own an Oil Wagon!',
    SellOilWagon = 'Sell Your Oil Wagon?',
    NotEnoughCash = 'You do not have enough money!',
    WagonSold = 'Wagon Sold',
    NoWagontoSell = 'You do not have a wagon to sell',
    WagonSpawned = 'Your Wagon has been delivered! Look for the blip',
    SpawnOilWagon = 'Call Your Oil Wagon?',
    NoWagonOwned = 'You do not own a wagon',
    WagonInSpawnLocation = 'Can not spawn, another wagon is too close to the spawn!',
    Supplymenuname = 'Supply Menu',
    OilMenuName = 'Oil Menu',
    BuySupplyWagon = 'Buy Supply Wagon?',
    SupplyWagonBought = 'You bought a supply wagon!',
    SupplyWagonAlreadyBought = 'You already own a supply wagon!',
    SellSupplyWagon = 'Sell your supply wagon?',
    SpawnSupplyWagon = 'Call your supply wagon?',
    FillYourOilWagon = 'Go to the mark to fill your wagon with oil!',
    FillBlipName = 'Fill Your Oil Wagon Here',
    FillingOilwagon = 'Filling Oil Wagon',
    GoDeliver = 'Go To the location, and deliver the oil. It has been marked on your map',
    DeliverBlipName = 'Delivery Location',
    OilDelivered = 'Oil Delivered!',
    UnloadingOil = 'Transfering oil',
    ReturnOilWagon = 'Go to the Oil Company, and return your wagon to storage!',
    ReturnBlip = 'Return Point',
    CollectOilDeliveryPay = 'Go to the company manager and collect your pay!',
    ThankYouHeresYourPayOil = 'Thank you! Here is your reward for a job well done!',
    CooldownActive = 'You have recently done a job for me wait a while',
    Missionfailed = 'Mission Failed',
    SupplyWagonMisisonBegin = 'Go to the marker on your map and collect the supplies',
    Pickupsupplyblip = 'Pick Up supplies here',
    Fillingsupplywagon = 'Fill supply wagon',
    Grabbingsupplies = 'Grabbing Supplies',
    Putsuppliesonwagon = 'Now Take the supplies to your wagon',
    DeliverSupplies = "Go to the marker and deliver the supplies",
    Suppliesdelivered = 'Supplies delivered, go back to the oil manager to recieve your pay',
    GetSuppliesFromWagon = 'Go get the supplies off the wagon',
    ReturnSupplyWagon = 'Go take your wagon back to the oil company',
    AlreadyInMission = 'You are already in a mission',
    CriminalPedBlip = 'Criminal Hideout', --Criminal Blip Name
    CriminalDrawText = 'Press "G" To Open The Menu',
    NUISellOilWagon = 'Sell Oil Wagon for ',
    NUIBuyOilWagon = 'Buy Oil Wagon for ',
    NUIDeliverMission = 'Delivery Mission?',
    NUIBuySupplyWagon = 'Buy Supply Wagon for ',
    NUISellSupplyWagon = 'Sell Supply Wagon for ',
    NUIExitMenu = 'Exit Menu',
    NUIRobOilCompany = 'Rob The Oil Company',
    NUIRobOilWagon = 'Steal a Oil Wagon',
    NUIOilMenu = 'Oil Menu',
    NUISupplyMenu = 'Supply Menu',
    RobOilWagonOpeningtext = 'I have marked the location of the wagon, go too it and steal it!',
    RobOilWagonKillGaurds = 'Kill the gaurds!!',
    RobOilWagonReturnWagon = 'Now Take the wagon to the drop off location!',
    RobOilWagonReturnBlip = 'Drop Off Location',
    RobOilWagonSuccess = 'You sucessfully stole the wagon! Good Job Heres your pay!',
    RobOilCoBlip = 'Rob The Oil Company',
    RobberySuccess = 'You Robbed the oil company now flee!',
    PressGToLockPick = 'Press "G" To LockPick',
    DefendAgainstAttackers = 'You are being attacked defend yourself!',
    Cooldown = 'Has Been Robbed Recently',
    SniffOil = 'Press "G" to sniff oil!',
    RobberyTitle = 'Robbery!',
    BoughtTitle = 'Wagon Bought',
    bought_desc = 'Player bought a supply wagon character static id: ',
    bought_desc2 = 'Player bought a oil wagon character static id: ',
    SoldTitle = 'Wagon Sold',
    sold_desc = 'Player sold a oil wagon Character Static Id: ',
    sold_desc2 = 'Player sold a supply wagon Character Static Id: ',
    DeliveryMissionTitle = 'Delivery Started',
    Delivery_desc = 'Player has begun delivering oil, players character static id: ',
    Delivery_desc2 = 'Player has begun delivering supplies, players character static id: ',
    Robbery_desc = 'Player has begun robbing the oil company, player character static id: ',
    Robbery_desc2 = 'Player has begun stealing an oil wagon, player character static id: ',
    SupplyWagonBlipName = 'Supply Wagon', -- suply wagon blip name
    OilWagonBlipName = 'Oil Wagon' -- oil wagon blip name
}

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