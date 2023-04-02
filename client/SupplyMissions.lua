--------------------------------------- Pulling Essentials -------------------------------------------
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)

function supplymissionbeginstage() --function used to fill your wagon with the supplies
    local repeatamount = 0 --variable used in the repeat to make the code in the repeat run 3 times
    repeat --repeat until repeatamount == 3 (this basically allows this code to run 3 times similar to if you made a function of this code and called it 3 times, just does it in less code)
        repeatamount = repeatamount + 1 --repeat amount = repeatamount + 1 so everytime this is ran it will add one
        --Begining setup and blip setup
        VORPcore.NotifyRightTip(Config.Language.SupplyWagonMisisonBegin, 4000) --prints on your screen
        local mathr1 = math.random(1, #SupplyMission.SupplyMisisonPickupLocation) --Gets a random set of coords from table
        local fillcoords = SupplyMission.SupplyMisisonPickupLocation[mathr1] --gets a random set of coords from table(table is in the config)
        local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, 5) --creates blip using natives
        Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.Pickupsupplyblip) --names blip
        --Waypointsetup
        local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
        StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
        AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
        AddPointToGpsMultiRoute(fillcoords.location.x, fillcoords.location.y, fillcoords.location.z) --Where the waypoint is set too
        SetGpsMultiRouteRender(true) --sets the waypoint to active
        FreezeEntityPosition(Createdwagon, true) --freezes wagon in  place
        local deadcheck = false --creates a variable used as a dead check
        while true do --creates a loop
            Citizen.Wait(60) --waits 60 ms meaning this loop runs every 60 ms
            if Playerdead == true or WagonDestroyed == true then --if you or wagon dead then
                deadcheck = true break --set variable true and breaks loop
            end
            local wc = GetEntityCoords(PlayerPedId()) --gets players coords
            if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, fillcoords.location.x, fillcoords.location.y, fillcoords.location.z, true) < 3 then break end --if you are closer than 3 to the coords then break loop allowing code below to run
        end
        if deadcheck == true then --if variable true then
            RemoveBlip(blip1) --removes blip
            ClearGpsMultiRoute() --clears gps
            repeatamount = 3
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns to end the function here not allowing more code below to run failing mission
        end
        RemoveBlip(blip1) --removes blip
        ClearGpsMultiRoute() --clears gps
        --pulled from syn construction
        VORPcore.NotifyRightTip(Config.Language.Grabbingsupplies, 3000) --prints on screen
        FreezeEntityPosition(PlayerPedId(), true) --freezes player
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), 4000, true, false, false, false) --triggers anim
        Wait(4000) --waits 4 seconds allowing anim to finish
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false) --unfreezes player
        local props = CreateObject(GetHashKey("p_crate03x"), 0, 0, 0, 1, 0, 1) --spawns the object at 0 0 0
        SetEntityAsMissionEntity(prop,true,true) --sets entity as mission entity
        RequestAnimDict("mech_carry_box") --loads the anim
        while not HasAnimDictLoaded("mech_carry_box") do --while the anim hasnt loaded do
            Citizen.Wait(100) --wait 0.1 second
        end
        Citizen.InvokeNative(0xEA47FE3719165B94, PlayerPedId() ,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0) --plays animation
        Citizen.InvokeNative(0x6B9BBD38AB0796DF, props, PlayerPedId() ,GetEntityBoneIndexByName(PlayerPedId(),"SKEL_R_Finger12"), 0.20, 0.028, -0.15, 100.0, 205.0, 20.0, true, true, false, true, 1, true) --puts object in your hand
        VORPcore.NotifyRightTip(Config.Language.Putsuppliesonwagon, 4000) --prints on screen
        while true do --creates loop
            Citizen.Wait(60) --waits 60 ms
            local pl = GetEntityCoords(PlayerPedId()) --gets your coords
            local wc = GetEntityCoords(Createdwagon) --gets wagons coords
            if Playerdead == true or WagonDestroyed == true then --if you or wagon dead then
                deadcheck = true break --set variable true and break loop
            end
            if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, wc.x, wc.y, wc.z, true) < 3 then --if you are closer than 3 to wagon then
                DeleteEntity(props) --delete prop(box)
                ClearPedTasksImmediately(PlayerPedId()) break --clears your anim and breaks loop
            end
        end
        if deadcheck == true then --if variable true then
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
    local deadcheck = false --creates local variable used too see if your dead
    local mathr1 = math.random(1, #Config.SupplyDeliveryLocations) --Gets a random set of coords from table
    local fillcoords = Config.SupplyDeliveryLocations[mathr1] --gets a random set of coords from table(table is in the config)
    VORPcore.NotifyRightTip(Config.Language.DeliverSupplies, 4000) --prints on screen
    repeat --repeat until
        repeatamount = repeatamount + 1 --adds 1 to the repeat amount variable
        --Begining setup and blip setup
        local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.x, fillcoords.y, fillcoords.z, 5) --creates blip using natives
        Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.DeliverSupplies) --names blip
        --Waypointsetup
        local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
        StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
        AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
        AddPointToGpsMultiRoute(fillcoords.x, fillcoords.y, fillcoords.z) --Where the waypoint is set too
        SetGpsMultiRouteRender(true) --sets the waypoint to active
        while true do --creates loop
            Citizen.Wait(60) --waits 60 ms prevents crashing
            if Playerdead or WagonDestroyed then --if you died or wagon broke then
                deadcheck = true break --variable = true break loop
            end
            local wc = GetEntityCoords(Createdwagon) --gets wagons coords
            if GetDistanceBetweenCoords(wc.x, wc.y,wc.z, fillcoords.x, fillcoords.y, fillcoords.z, true) < 15 then --if the dist is less than 15 then
                TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) break --makes the player get off the wagon
            end
        end
        FreezeEntityPosition(Createdwagon, true) --freezes the wagon
        VORPcore.NotifyRightTip(Config.Language.GetSuppliesFromWagon, 4000) --prints on screen
        if deadcheck then --if deadcheck true then
            RemoveBlip(blip1) --removes blip
            ClearGpsMultiRoute() --removes gps
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
            repeatamount = 3 return --sets variable too 3 preventing the repeat from running again then returns to end the function here
        end
        while true do --creates loop
            Citizen.Wait(60) --waits 60 ms
            if Playerdead or WagonDestroyed then --if you or wagon dead then
                deadcheck = true break --variable = true break loop
            end
            local pl = GetEntityCoords(PlayerPedId()) --gets your coords
            local wc = GetEntityCoords(Createdwagon) --gets wagons coords
            if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, wc.x, wc.y, wc.z, true) < 3 then break end --if player closer than 3 then break
        end
        if deadcheck then --if deadcheck true then
            repeatamount = 3 --sets variable too 3
            RemoveBlip(blip1) --removes blip
            ClearGpsMultiRoute() --clears gps
            VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns to break function here
        end
        VORPcore.NotifyRightTip(Config.Language.DeliverSupplies, 4000) --prints on screen
        local props = CreateObject(GetHashKey("p_crate03x"), 0, 0, 0, 1, 0, 1) --spawns the object at 0 0 0
        SetEntityAsMissionEntity(prop,true,true) --sets entity as mission entity
        RequestAnimDict("mech_carry_box") --loads the anim
        while not HasAnimDictLoaded("mech_carry_box") do --while the anim hasnt loaded do
            Citizen.Wait(100) --wait 0.1 second
        end
        Citizen.InvokeNative(0xEA47FE3719165B94, PlayerPedId() ,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0) --plays animation
        Citizen.InvokeNative(0x6B9BBD38AB0796DF, props, PlayerPedId() ,GetEntityBoneIndexByName(PlayerPedId(),"SKEL_R_Finger12"), 0.20, 0.028, -0.15, 100.0, 205.0, 20.0, true, true, false, true, 1, true) --puts object in your hand
        while true do --creates loop
            Citizen.Wait(60) --waits 60ms
            if Playerdead or WagonDestroyed then --if player or wagon dead then
                deadcheck = true break --variable = true break loop
            end
            local pl = GetEntityCoords(PlayerPedId()) --gets players coords
            if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, fillcoords.x, fillcoords.y, fillcoords.z, true) < 2 then break end --if closer than 2 then break loop
        end
        DeleteEntity(props) --deletes the prop(box)
        ClearPedTasksImmediately(PlayerPedId()) --clears players animations
        RemoveBlip(blip1) --removes blip
    until repeatamount == 3 --repeats until the variable = 3 then it wont repeat again
    if deadcheck then --if variable true then
        RemoveBlip(blip1) --remove blip
        ClearGpsMultiRoute() --clear gps
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns ending the function here
    end
    ClearGpsMultiRoute() --clears gps
    FreezeEntityPosition(Createdwagon, false) --unfreezes the wagon
    supplymissionend() --triggers the next function
end

function supplymissionend()
    local deadcheck = false --sets variable too false
    VORPcore.NotifyRightTip(Config.Language.ReturnSupplyWagon, 4000) --prints on screen
    --Begining setup and blip setup
    local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5) --creates blip using natives
    Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.ManagerBlip) --names blip
    --Waypointsetup
    local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
    StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
    AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
    AddPointToGpsMultiRoute(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z) --Where the waypoint is set too
    SetGpsMultiRouteRender(true) --sets the waypoint to active
    while true do --creates loop
        Citizen.Wait(60) --waits 60ms
        if Playerdead or WagonDestroyed then --if you or wagon dead then
            deadcheck = true break --variable = true then break loop
        end
        local wc = GetEntityCoords(Createdwagon) --gets wagons coords
        if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, true) < 5 then break end
    end
    if deadcheck then --if variable true then
        RemoveBlip(blip1) --remove blip
        ClearGpsMultiRoute() --clears gps
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then return too end function here
    end
    TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
    FreezeEntityPosition(Createdwagon, true) --freezes the wagon
    RemoveBlip(blip1) --removes the blip
    ClearGpsMultiRoute() --clears gps
    VORPcore.NotifyRightTip(Config.Language.CollectOilDeliveryPay, 4000) --prints on screen
    while true do --creates loop
        Citizen.Wait(60) --waits 60ms
        if Playerdead or WagonDestroyed then --if either are true then
            deadcheck = true break --variable = true breaks loop
        end
        local pl = GetEntityCoords(PlayerPedId()) --gets your coords
        if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, true) < 3 then break end
    end
    if deadcheck then --if true then
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --print on screen then return too end function here
    end
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