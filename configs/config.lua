Config = {
    WebhookLink = '', -- insert your webhook link here (leave empty for no webhooks)
    defaultlang = "en_lang",
    ------------------------------------------ Oil Job Setup ---------------------------------------------------
    ---------Oil Part of the job -------------
    OilandSupplyWagonSpawn = vector4(526.83, 703.01, 117.0, 263.92), -- Coords your oil and supply wagons will spawn at
    ManagerBlip = true, -- If true will create a blip on the Manager, if false it will not
    ManagerPedModel = 'u_m_m_cktmanager_01', -- This is the model the manager will spawn as
    OilWagon = {
        price = 100,
        sellprice = 80
    }, -- Oil wagon model hash theres 2 but there the same(making this easily changeable incase you do want to change the model)
    OilWagonFillTime = 10000, -- time in ms it takes to fill the oil wagon aswell as unload when delivering oil
    BasicOilDeliveryPay = 50, -- This is the base pay rate for doing an oil mission (the payoutbonus in the OilCompanyLevels will be added to this amount)
    LevelIncreasePerDelivery = 1, -- sets the amount your level increases per delivery mission
    --------------------- config player's wagon blip---------------------------
    OilWagonBilpHash = 1612913921, -- Set Oil Wagon blip icon using blip hashes (https://redlookup.com/blips)
    OilWagonBlipColor = 'BLIP_MODIFIER_MP_COLOR_32', -- Set Supply wagon blip color. you can find the colors you can use in the end of this config file
    SupplyWagonBilpHash = 1612913921, -- Set Supply Wagon blip icon using blip hashes (https://redlookup.com/blips)
    SupplyWagonBlipColor = 'BLIP_MODIFIER_MP_COLOR_32', -- Set Supply wagon blip color. you can find the colors you can use in the end of this config file
    ------------------------ config company manager blip and criminal blip-------------------------
    ManagerBlipHash = 1000514759,
    ManagerBlipColor = 'BLIP_MODIFIER_MP_COLOR_2',
    CriminalBlipHash = 1000514759,
    CriminalBlipColor = 'BLIP_MODIFIER_MP_COLOR_2',

    -------------This is the levels, and what they pay-----------------------------------------
    -- This level setup is for the entire oil company this will effect payout for basic jobs etc(You can add or remove levels as you please but there has to be atleast 1)
    SniffOil = { -- oil sniffing setup
        enable = true, -- if true players will be able to sniff oil and get high
        Coords = vector3(485.47, 678.98, 117.31), -- coords you will have to go to to sniff oil
        EffectTime = 30000 -- the time the screen effect will last
    },

    OilCompanyLevels = {{
        level = 10, -- this is the level you have to be at or above to get the bonus
        payoutbonus = 20, -- this is how much extra you will get when finishing a delivery mission
        nextlevel = 20 -- this has to be the next level so since the next level is 20 this has to be 20
    }, {
        level = 20,
        payoutbonus = 40,
        nextlevel = 30
    }, {
        level = 30,
        payoutbonus = 100,
        nextlevel = 40
    }},

    --------Place Where You Will Go To Deliver The Oil, It Picks Randomly Each Delivery--------
    OilDeliveryPoints = {
        {
            DeliveryPoint = vector3(-223.44, 642.03, 113.14), -- the point you have to go to
            NpcSpawn = vector4(-226.0, 632.26, 113.21, 200) -- the point the npc will spawn make this close to the deliverypoint coords
        },
        {
            DeliveryPoint = vector3(-172.01, 652.05, 113.73),
            NpcSpawn = vector4(-179.5, 650.0, 113.58, 200)
        },
        {
            DeliveryPoint = vector3(1512.84, 432.9, 89.75),
            NpcSpawn = vector4(1517.0, 430.76, 90.68, 85.02)
        },
        {
            DeliveryPoint = vector3(-350.52, -346.21, 88.03),
            NpcSpawn = vector4(-349.24, -348.96, 87.46, 17.93)
        },
        {
            DeliveryPoint = vector3(581.11, 1691.88, 24.46),
            NpcSpawn = vector4(582.75, 1694.28, 187.43, 15.42)
        }
    },

    ------Supply part of the job-----------
    SupplyWagon = {
        price = 200,
        sellprice = 150
    }, -- price and sell price of supply wagon
    FillySupplyWagonTime = 10000, -- time it will take to fill your supply wagon
    SupplyDeliveryBasePay = 70, -- Base pay for delivering supplies

    -- These are the locations the script will randomly pick one from them to make you deliver too
    SupplyDeliveryLocations = {
        vector3(781.75, 854.34, 118.36),
        vector3(1100.41, 493.49, 95.63),
        vector3(891.75, 266.95, 116.3)
    },

    --------------Criminal Job Setup----------------------------------------------
    CriminalPedSpawn = vector4(1466.55, 802.93, 100.13, 231.88), -- this is the location the criminal ped that gives you jobs will spawn
    CriminalPedBlip = true, -- if enabled this will place a blip on the criminal peds location on the map
    CriminalPedModel = 'g_m_m_unicriminals_01', -- model of the criminal ped
    CriminalLevelIncrease = 1, -- this is how much your level will increase per job completed(this is for all jobs)
    OilCompanyLevelDecrease = 1, -- this is how much your oilco level will decrease upon doing a criminal misison
    StealOilWagonBasePay = 60, -- this is the base pay for stealing an oil wagon
    CrimBlipHash = 'blip_mp_torch', -- Blip hash
    RobOilWagonCooldown = 720000, -- Amount of time in ms that has to pass before anyone can rob the oil wagon again
    RobOilCoCooldown = 120000, -- Time in ms before a player can rob the oil company again

    -----Level Setup-----
    CriminalLevels = {
        {
            level = 10, -- this is the level you have to be at or above to get the bonus
            payoutbonus = 2000, -- this is how much extra you will get when finishing a delivery mission
            nextlevel = 20 -- this has to be the next level so since the next level is 20 this has to be 20
        },
        {
            level = 20,
            payoutbonus = 40,
            nextlevel = 30
        },
        {
            level = 30,
            payoutbonus = 100,
            nextlevel = 40
        }
    },

    ----Steal Oil Wagon Setup-----
    OilWagonrobberyLocations = {
        {
            wagonLocation = vector3(381.15, -21.5, 109.09),
            wagonHeading = 360,
            pedlocation = {
                {vector3(384.9, -23.37, 109.06)},
                {vector3(383.09, -19.78, 108.91)},
                {vector3(381.08, -13.82, 108.57)}
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        }
    },

    ---Rob Oil Company Setup----
    RobOilCoEnemyPeds = false, -- if true enemy peds will spawn when you are done lockpicking to fight you
    RobOilCoEnemyPedsLocations = {
        {vector3(505.34, 700.74, 116.05)},
        {vector3(503.61, 689.27, 117.48)},
        {vector3(507.35, 682.53, 117.39)},
        {vector3(512.52, 686.54, 117.4)}
    },

    LockPick = {
        MaxAttemptsPerLock = 3,
        lockpickitem = 'lockpick',
        difficulty = 10,
        hintdelay = 500
    },

    RobOilCompany = {
        {
            lootlocation = vector3(493.83, 675.16, 117.39), -- location where you will have to go to lockpick
            rewards = { -- this will handle the rewards
                itemspayout = true, -- if true it will give items, if false it will just pay the cash amount set below
                cashpayout = 300, -- this is the amount of cash it will give you
                items = { -- this will handle the items
                    {
                        item = 'trainoil', -- name of the item in DB
                        count = 10 -- count you want it too give
                    }, {
                        item = 'bagofcoal',
                        count = 10
                    } -- you can set more items use this as an example to add more
                }
            }
        }, -- you can add more locations to this, the script will randomly choose one table each robbery too add more just copy paste table change what you need
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
}
