--------------------------------------- Pulling Essentials -------------------------------------------
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)
local VORPutils = {}
TriggerEvent("getUtils", function(utils)
  VORPutils = utils
end)

--Function for beggining the mission
function supplymissionbeginstage() --function used to fill your wagon with the supplies
    local repeatamount = 0 --variable used in the repeat to make the code in the repeat run 3 times
    repeat --repeat until repeatamount == 3 (this basically allows this code to run 3 times similar to if you made a function of this code and called it 3 times, just does it in less code)
        repeatamount = repeatamount + 1 --repeat amount = repeatamount + 1 so everytime this is ran it will add one
        VORPcore.NotifyRightTip(Config.Language.SupplyWagonMisisonBegin, 4000) --prints on your screen

        --Coord Randomization
        local mathr1 = math.random(1, #SupplyMission.SupplyMisisonPickupLocation) --Gets a random set of coords from table
        local fillcoords = SupplyMission.SupplyMisisonPickupLocation[mathr1] --gets a random set of coords from table(table is in the config)
        
        --Blip and Waypoint Setup
        local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, 5) --creates blip using natives
        Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.Pickupsupplyblip) --names blip
        VORPutils.Gps:SetGps(fillcoords.location.x, fillcoords.location.y, fillcoords.location.z) --Creates the gps waypoint
        
        --Distance Check Setup for picking up boxes
        FreezeEntityPosition(Createdwagon, true) --freezes wagon in  place
        distcheck(fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, 3, PlayerPedId())
        if Playerdead or WagonDestroyed then --if variable true then
            RemoveBlip(blip1) --removes blip
            VORPutils.Gps:RemoveGps() --Removes the gps waypoint
            repeatamount = 3
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns to end the function here not allowing more code below to run failing mission
        end
        RemoveBlip(blip1) --removes blip
        ClearGpsMultiRoute() --clears gps

        --pulled from syn construction, carrying box setup
        VORPcore.NotifyRightTip(Config.Language.Grabbingsupplies, 3000) --prints on screen
        FreezeEntityPosition(PlayerPedId(), true) --freezes player
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), 4000, true, false, false, false) --triggers anim
        Wait(4000) --waits 4 seconds allowing anim to finish
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false) --unfreezes player
        local props = CreateObject(GetHashKey("p_crate03x"), 0, 0, 0, 1, 0, 1) --spawns the object at 0 0 0
        PlayerCarryBox(props) --triggers function to make player carry the box
        VORPcore.NotifyRightTip(Config.Language.Putsuppliesonwagon, 4000) --prints on screen
        
        --Dist Check Setup for player to wagon loading boxes onto wagon
        local wc = GetEntityCoords(Createdwagon) --gets the wagons coords
        distcheck(wc.x, wc.y, wc.z, 3, PlayerPedId())
        ClearPedTasksImmediately(PlayerPedId()) --clears your anim
        DeleteEntity(props) --delete object
        if Playerdead or WagonDestroyed then --if variable true then
            repeatamount = 3 --sets repeat amount to 3 so the repeat wont run again if you die
            DeleteEntity(props) --delete object
            ClearPedTasksImmediately(PlayerPedId()) --clears your anim
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns ending function here failing mission
        end
    until repeatamount == 3 --if variable == 3 then it will not repeat again if less than 3 it will repeat
    FreezeEntityPosition(Createdwagon, false) --unfreezes the wagon once the repeat is over
    deliversupplies() --triggers the next function/part of mission
end

function deliversupplies()
    local repeatamount = 0 --sets repeat amount too 0

    --Coords Randomization
    local mathr1 = math.random(1, #Config.SupplyDeliveryLocations) --Gets a random set of coords from table
    local fillcoords = Config.SupplyDeliveryLocations[mathr1] --gets a random set of coords from table(table is in the config)
    VORPcore.NotifyRightTip(Config.Language.DeliverSupplies, 4000) --prints on screen
    
    --Mission Start
    repeat --repeat until
        repeatamount = repeatamount + 1 --adds 1 to the repeat amount variable
        
        --Blip and Waypoint Setup
        local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.x, fillcoords.y, fillcoords.z, 5) --creates blip using natives
        Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.DeliverSupplies) --names blip
        VORPutils.Gps:SetGps(fillcoords.x, fillcoords.y, fillcoords.z) --creates waypoint

        --Dist Check Setup wagon to drop off location
        distcheck(fillcoords.x, fillcoords.y, fillcoords.z, 15, Createdwagon)
        if Playerdead or WagonDestroyed then --if deadcheck true then
            RemoveBlip(blip1) --removes blip
            VORPutils.Gps:RemoveGps() --Removes the gps waypoint
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
            repeatamount = 3 return --sets variable too 3 preventing the repeat from running again then returns to end the function here
        end
        FreezeEntityPosition(Createdwagon, true) --freezes the wagon
        VORPcore.NotifyRightTip(Config.Language.GetSuppliesFromWagon, 4000) --prints on screen

        --Dist Check Player to pick up supplies from wagon
        local wc = GetEntityCoords(Createdwagon)
        distcheck(wc.x, wc.y, wc.z, 3, PlayerPedId())
        if Playerdead or WagonDestroyed then --if deadcheck true then
            repeatamount = 3 --sets variable too 3
            RemoveBlip(blip1) --removes blip
            VORPutils.Gps:RemoveGps() --Removes the gps waypoint
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns to break function here
        end
        VORPcore.NotifyRightTip(Config.Language.DeliverSupplies, 4000) --prints on screen
        
        --Picking up/ Holding Supplies animation setup
        local props = CreateObject(GetHashKey("p_crate03x"), 0, 0, 0, 1, 0, 1) --spawns the object at 0 0 0
        PlayerCarryBox(props) --triggers the function to make the player hold the box

        --Dist check setup for delivering the supples
        distcheck(fillcoords.x, fillcoords.y, fillcoords.z, 2, PlayerPedId())
        DeleteEntity(props) --deletes the prop(box)
        ClearPedTasksImmediately(PlayerPedId()) --clears players animations
        RemoveBlip(blip1) --removes blip
    until repeatamount == 3 --repeats until the variable = 3 then it wont repeat again
    if Playerdead or WagonDestroyed then --if variable true then
        RemoveBlip(blip1) --remove blip
        VORPutils.Gps:RemoveGps() --Removes the gps waypoint
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns ending the function here
    end
    VORPutils.Gps:RemoveGps() --Removes the gps waypoint
    FreezeEntityPosition(Createdwagon, false) --unfreezes the wagon
    supplymissionend() --triggers the next function
end

function supplymissionend()
    VORPcore.NotifyRightTip(Config.Language.ReturnSupplyWagon, 4000) --prints on screen
    
    --Blip and Waypoint Setup
    local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5) --creates blip using natives
    Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.ManagerBlip) --names blip
    VORPutils.Gps:SetGps(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z) --creates waypoint
    
    --Dist check setup wagon to return spot
    distcheck(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5, Createdwagon)
    if Playerdead or WagonDestroyed then --if variable true then
        RemoveBlip(blip1) --remove blip
        VORPutils.Gps:RemoveGps() --Removes the gps waypoint
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then return too end function here
    end
    TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
    FreezeEntityPosition(Createdwagon, true) --freezes the wagon
    RemoveBlip(blip1) --removes the blip
    VORPutils.Gps:RemoveGps() --Removes the gps waypoint
    VORPcore.NotifyRightTip(Config.Language.CollectOilDeliveryPay, 4000) --prints on screen
    
    --Distance check player to manager setup
    distcheck(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, 3, PlayerPedId())
    if Playerdead or WagonDestroyed then --if true then
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --print on screen then return too end function here
    end

    --Mission end setup
    VORPcore.NotifyRightTip(Config.Language.ThankYouHeresYourPayOil, 4000) --prints on screen
    DeleteEntity(Createdwagon) --deletes wagon
    TriggerServerEvent('bcc:oil:WagonHasLeftSpawn') --triggers the server event to allow wagons to spawn again (if this is not here no wagons will be able to spawn even though the players wagon has been deleted)
    TriggerServerEvent('bcc:oil:PayoutOilMission', Wagon) --triggers the server event to add the money to your character(event uses the level system to add money depending on level)
    Inmission = false --sets var false allowing player to start a new mission
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