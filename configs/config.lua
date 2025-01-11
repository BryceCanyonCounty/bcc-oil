Config = {
    WebhookLink = '', -- insert your webhook link here (leave empty for no webhooks)
    defaultlang = "en_lang",
    ------------------------------------------ Oil Job Setup ---------------------------------------------------
    ---------Oil Part of the job -------------
    OilManagerNPC = {x = 496.91, y = 704.15, z = 117.35, h = 174.79}, --Coords of your Manager-NPC
    OilandSupplyWagonSpawn = vector4(505.06, 704.62, 116.07, 176.31), -- Coords your oil and supply wagons will spawn at
    ManagerBlip = true, -- If true will create a blip on the Manager, if false it will not
    ManagerPedModel = 'u_m_m_cktmanager_01', -- This is the model the manager will spawn as
    OilWagon = {
        price = 100,
        sellprice = 80
    }, -- Oil wagon model hash theres 2 but there the same(making this easily changeable incase you do want to change the model)
    OilWagonFillTime = 10000, -- time in ms it takes to fill the oil wagon aswell as unload when delivering oil
    BasicOilDeliveryPay = 60, -- This is the base pay rate for doing an oil mission (the payoutbonus in the OilCompanyLevels will be added to this amount)
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
            payoutbonus = 20, -- this is how much extra you will get when finishing a delivery mission
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
            pedweapons= `WEAPON_REPEATER_CARBINE`,
            wagonLocation = vector3(381.15, -21.5, 109.09),
            wagonHeading = 360,
            pedlocation = {
                vector3(384.9, -23.37, 109.06),
                vector3(383.09, -19.78, 108.91),
                vector3(381.08, -13.82, 108.57),
                vector3(375.3, -14.91, 108.17),
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        },
        {
            pedweapons= `WEAPON_REPEATER_HENRY`,
            wagonLocation = vector3(-4694.46, -3723.12, 12.98),
            wagonHeading = 303.74,
            pedlocation = {
                vector3(-4684.33, -3730.38, 13.08),
                vector3(-4679.84, -3738.61, 13.61),
                vector3(-4683.74, -3752.86, 13.36),
                vector3(-4699.91, -3752.19, 12.95),
                vector3(-4703.97, -3742.73, 12.62),
                vector3(-4701.82, -3736.54, 12.7),
                vector3(-4706.01, -3717.2, 11.97),
                vector3(-4699.23, -3706.16, 11.88),
                vector3(-4688.21, -3703.34, 12.64),
                vector3(-4674.68, -3705.58, 13.3)
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        },
        {
            pedweapons= `WEAPON_REPEATER_CARBINE`,
            wagonLocation = vector3(-3010.99, -2317.49, 38.7),
            wagonHeading = 212.74,
            pedlocation = {
                vector3(-3004.78, -2332.43, 39.28),
                vector3(-3003.08, -2311.18, 39.36),
                vector3(-2995.0, -2325.41, 39.23),
                vector3(-3018.54, -2338.29, 45.37),
                vector3(-3028.35, -2304.07, 46.17),
                vector3(-3020.79, -2286.19, 47.12),
                vector3(-3006.47, -2272.46, 48.41)
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        },
        {
            pedweapons= `WEAPON_SHOTGUN_REPEATING`,
            wagonLocation = vector3(-2312.85, -14.12, 255.22),
            wagonHeading = 295.21,
            pedlocation = {
                vector3(-2308.61, -16.38, 254.84),
                vector3(-2297.6, -6.81, 256.31),
                vector3(-2296.29, 2.73, 257.33),
                vector3(-2305.65, 7.28, 254.02),
                vector3(-2307.42, 18.92, 251.33)
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        },
        {
            pedweapons= `WEAPON_RIFLE_VARMINT`,
            wagonLocation = vector3(-1349.34, 2418.56, 307.07),
            wagonHeading = 153.59,
            pedlocation = {
                vector3(-1345.91, 2405.99, 307.07),
                vector3(-1345.07, 2403.42, 307.07),
                vector3(-1357.91, 2417.65, 307.49),
                vector3(-1353.4, 2430.75, 307.83),
                vector3(-1339.34, 2444.65, 308.6),
                vector3(-1331.2, 2442.4, 308.83)
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        },
        {
            pedweapons = `WEAPON_REVOLVER_SCHOFIELD`,
            wagonLocation = vector3(2269.9, 1258.41, 96.75),
            wagonHeading = 50.1,
            pedlocation = {
                vector3(2259.96, 1255.05, 100.72),
                vector3(2260.04, 1267.11, 97.75),
                vector3(2266.26, 1274.16, 95.15),
                vector3(2273.79, 1272.54, 94.58),
                vector3(2288.33, 1274.08, 86.71),
                vector3(2327.15, 1286.78, 85.59),
                vector3(2333.6, 1289.28, 88.68)
            },
            returnlocation = vector3(1479.15, 804.79, 100.28)
        }
    },

    ---Rob Oil Company Setup----
    RobOilpedweapons = `WEAPON_REPEATER_CARBINE`,
    RobOilCoEnemyPeds = true, -- if true enemy peds will spawn when you are done lockpicking to fight you
    RobOilCoEnemyPedsLocations = {
        vector3(505.34, 700.74, 116.05),
        vector3(503.61, 689.27, 117.48),
        vector3(507.35, 682.53, 117.39),
        vector3(512.52, 686.54, 117.4) ,
        

    },

    LockPick = {
        MaxAttemptsPerLock = 5,
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
                        item = 'goldbar', -- name of the item in DB
                        count = 3 -- count you want it too give
                    }, {
                        item = 'coal',
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
