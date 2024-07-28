local T = Translation.Langs[Config.Lang]

--Function for beggining the mission
function supplymissionbeginstage()
    local repeatamount, pl = 0, PlayerPedId()
    repeat
        repeatamount = repeatamount + 1
        -- VORPcore.NotifyRightTip(T.SupplyWagonMisisonBegin, 4000)
        Notify(0, T.SupplyWagonMisisonBegin, 'info')

        --Coord Randomization
        local fillcoords = CoordRandom(SupplyMission.SupplyMisisonPickupLocation)

        --Blip and Waypoint Setup
        local blip1 = BlipWaypoin(fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, T.Pickupsupplyblip)

        --Distance Check Setup for picking up boxes
        FreezeEntityPosition(Createdwagon, true)
        distcheck(fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, 3, pl)
        ClearGpsMultiRoute()
        if Playerdead or WagonDestroyed then
            RemoveBlip(blip1)
            repeatamount = 3
            Notify(0, T.Missionfailed, 'fail') return
            -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
        end
        RemoveBlip(blip1)

        --pulled from syn construction, carrying box setup
        Notify(0, T.Grabbingsupplies, 'info')
        -- VORPcore.NotifyRightTip(T.Grabbingsupplies, 3000)
        FreezeEntityPosition(pl, true)
        TaskStartScenarioInPlace(pl, joaat('WORLD_HUMAN_FARMER_WEEDING'), 4000, true, false, false, false)
        Wait(4000)
        ClearPedTasksImmediately(pl)
        FreezeEntityPosition(pl, false)
        local props = CreateObject(joaat("p_crate03x"), 0, 0, 0, 1, 0, 1)
        PlayerCarryBox(props)
        -- VORPcore.NotifyRightTip(T.Putsuppliesonwagon, 4000)
        Notify(0, T.Putsuppliesonwagon, 'info')

        --Dist Check Setup for player to wagon loading boxes onto wagon
        local wc = GetEntityCoords(Createdwagon)
        distcheck(wc.x, wc.y, wc.z, 3, pl)
        ClearPedTasksImmediately(pl)
        DeleteEntity(props)
        if Playerdead or WagonDestroyed then
            repeatamount = 3
            DeleteEntity(props)
            ClearPedTasksImmediately(pl)
            Notify(0, T.Missionfailed, 'fail') return
            -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
        end
    until repeatamount == 3
    FreezeEntityPosition(Createdwagon, false)
    deliversupplies()
end

function deliversupplies()
    local repeatamount, pl = 0, PlayerPedId()

    --Coords Randomization
    local fillcoords = CoordRandom(Config.SupplyDeliveryLocations)
    Notify(0, T.DeliverSupplies, 'info')
    -- VORPcore.NotifyRightTip(T.DeliverSupplies, 4000)

    --Mission Start
    repeat
        repeatamount = repeatamount + 1

        --Blip and Waypoint Setup
        local blip1 = BlipWaypoin(fillcoords.x, fillcoords.y, fillcoords.z, T.DeliverSupplies)

        --Dist Check Setup wagon to drop off location
        distcheck(fillcoords.x, fillcoords.y, fillcoords.z, 15, Createdwagon)
        if Playerdead or WagonDestroyed then
            RemoveBlip(blip1)
            ClearGpsMultiRoute()
            -- VORPcore.NotifyRightTip(T.Missionfailed, 4000)
            Notify(0, T.Missionfailed, 'fail')
            repeatamount = 3 return
        end
        FreezeEntityPosition(Createdwagon, true)
        -- VORPcore.NotifyRightTip(T.GetSuppliesFromWagon, 4000)
        Notify(0, T.GetSuppliesFromWagon, 'info')

        --Dist Check Player to pick up supplies from wagon
        local wc = GetEntityCoords(Createdwagon)
        distcheck(wc.x, wc.y, wc.z, 3, pl)
        if Playerdead or WagonDestroyed then
            repeatamount = 3
            RemoveBlip(blip1)
            ClearGpsMultiRoute()
            Notify(0, T.Missionfailed, 'fail') return
            -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
        end
        Notify(0, T.DeliverSupplies, 'info')
        -- VORPcore.NotifyRightTip(T.DeliverSupplies, 4000)

        --Picking up/ Holding Supplies animation setup
        local props = CreateObject(joaat("p_crate03x"), 0, 0, 0, 1, 0, 1)
        PlayerCarryBox(props)

        --Dist check setup for delivering the supples
        distcheck(fillcoords.x, fillcoords.y, fillcoords.z, 2, pl)
        DeleteEntity(props)
        ClearPedTasksImmediately(pl)
        RemoveBlip(blip1)
    until repeatamount == 3
    ClearGpsMultiRoute()
    if Playerdead or WagonDestroyed then
        RemoveBlip(blip1)
        Notify(0, T.Missionfailed, 'fail') return
        -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
    end
    FreezeEntityPosition(Createdwagon, false)
    supplymissionend()
end

function supplymissionend()
    -- VORPcore.NotifyRightTip(T.ReturnSupplyWagon, 4000)
    Notify(0, T.ReturnSupplyWagon, 'info')

    --Blip and Waypoint Setup
    local blip1 = BlipWaypoin(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, T.ManagerBlip)

    --Dist check setup wagon to return spot
    distcheck(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5, Createdwagon)
    ClearGpsMultiRoute()
    if Playerdead or WagonDestroyed then
        RemoveBlip(blip1)
        Notify(0, T.Missionfailed, 'fail')
        -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
    end
    TaskLeaveAnyVehicle(PlayerPedId(), 0, 0)
    FreezeEntityPosition(Createdwagon, true)
    RemoveBlip(blip1)

    Notify(0, T.CollectOilDeliveryPay, 'info')
    -- VORPcore.NotifyRightTip(T.CollectOilDeliveryPay, 4000)

    --Distance check player to manager setup
    distcheck(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, 3, PlayerPedId())
    if Playerdead or WagonDestroyed then
        Notify(0, T.Missionfailed, 'fail') return
        -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
    end

    --Mission end setup
    Notify(0, T.ThankYouHeresYourPayOil, 'success')
    -- VORPcore.NotifyRightTip(T.ThankYouHeresYourPayOil, 4000)
    DeleteEntity(Createdwagon)
    TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
    TriggerServerEvent('bcc:oil:PayoutOilMission', Wagon)
    Inmission = false
end

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
