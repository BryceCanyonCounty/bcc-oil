--------------------------------------- Pulling Essentials -------------------------------------------
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)
progressbar = exports.vorp_progressbar:initiate() --Allows use of progressbar in code

--[[##################################################################################################################################]]
---------------------------------Oil Delivery Mission Setup------------------------------------------------------------------------------------
--[[###################################################################################################################################]]
--Initial Fill Wagon Mission
function beginningstage() --creates a funtion named beginningstage (triggered in PlayerWagonSpawn.lua)
  Wait(1000) --waits 1 seconds time for the palyerwagonspawn.lua print too go away
  VORPcore.NotifyRightTip(Config.Language.FillYourOilWagon, 4000) --prints on your screen
  local mathr1 = math.random(1, #OilWagonTable.FillPoints) --Gets a random set of coords from OilWagontable.FillPoints
  local fillcoords = OilWagonTable.FillPoints[mathr1] --gets a random set of coords from OilWagonTable.FillPoints
  --Fill Point Blip
  local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.fillpoint.x, fillcoords.fillpoint.y, fillcoords.fillpoint.z, 5) --creates blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.FillBlipName) --names blip
  --Waypointsetup
  local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
  AddPointToGpsMultiRoute(fillcoords.fillpoint.x, fillcoords.fillpoint.y, fillcoords.fillpoint.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  -------------Dist Check for fill Setup-----------------
  local fillcheckdeadcheck = false --creates local variable used inside the loop below to check if the player or wagon is dead
  while true do --creates a loop that will run until break is done
    Citizen.Wait(10) --makes it wait 10 ms loop runs every 10 ms
    local wc = GetEntityCoords(Createdwagon) --sets variable to wagons coords
    if Playerdead == true or WagonDestroyed == true then --if player is dead or if wagon is destroyed (these variables are controlled in mainwagonspawn.lua) then
      fillcheckdeadcheck = true break --turns the variable true and breaks loop(this will disable the code below the loop from running stopping the mission)
    end
    if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, fillcoords.fillpoint.x, fillcoords.fillpoint.y, fillcoords.fillpoint.z, false) < 3 then break end --gets dist between coords if dist less than 3 then break loop and allow code below loop to run
  end
  if fillcheckdeadcheck == true then --if variable is true(you are dead or wagon destroyed) then
    RemoveBlip(blip1) --removes the blip
    ClearGpsMultiRoute() --clears the gps from your map
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then return(return ends the function preventing code below from running essentially creatin a dead check)
  end
  FreezeEntityPosition(Createdwagon, true) --freezes the wagon
  RemoveBlip(blip1) --removes blip
  ClearGpsMultiRoute() --clears gps
  -------Progress bar / Fill Wagon Setup----------
  TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
  VORPcore.NotifyRightTip(Config.Language.FillingOilwagon, 4000) --prints on screen
  Wait(3000) --waits 3 second for leaving wagon anim to finish
  local wch = GetEntityHeading(Createdwagon) --gets wagons heading
  Wait(300) --waits 200ms gives script time to get heading
  SetEntityHeading(PlayerPedId(), wch) --sets players heading to align the anim
  Wait(500) --waits 800 ms gives the script time to run it all
  TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), Config.OilWagonFillTime, true, false, false, false) --starts an anim that goes for the config time
  progressbar.start(Config.Language.FillingOilwagon, Config.OilWagonFillTime, function() --sets up progress bar to run while anim is
  end, 'circle') --part of progress bar
  Wait(Config.OilWagonFillTime) --waits until the anim / progressbar above is over
  if Progressbardeadcheck == true then --this will run once after the progressbar is over and will check if the varible is true if then(this does mean that if you die mid progress bar it will not detect it until after it is over but it removes the necessity of setting player and wagon invincible therefore increasing immersion)
    Progressbardeadcheck = false --resest the variable so you can do a new mission
    ClearPedTasksImmediately(PlayerPedId()) --clears tasks from player
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --printson screen
    DeleteEntity(Createdwagon) return --deletes wagon and return (deletewagon causes mission to fail in deadcheck, return ends the function here and does not allow it too continue(failing the mission))
  end
  ClearPedTasksImmediately(PlayerPedId()) --clears anim from ped
  TaskEnterVehicle(PlayerPedId(), Createdwagon, 4000, -1, 0) --sets player into driver seat of the wagon
  deliveroil() --triggers function for next part of mission
end

-----------------------Deliver oil Mission&return wagon included here------------------------------
function deliveroil()
  local deadcheck = false --creates a variable used for checking if your dead or wagon broke and ending code if so
  FreezeEntityPosition(Createdwagon, false) --unfreezes
  Wait(200) --waits 200 ms
  VORPcore.NotifyRightTip(Config.Language.GoDeliver, 4000) --prints on screen
  local mathr1 = math.random(1, #Config.OilDeliveryPoints) --Gets a random set of coords from config
  local fillcoords = Config.OilDeliveryPoints[mathr1] --gets a random set of coords from config
  --Deliver Point Blip
  local blip2 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.DeliveryPoint.x, fillcoords.DeliveryPoint.y, fillcoords.DeliveryPoint.z, 5) --creates a blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip2, Config.Language.DeliverBlipName) --names the blip
  --Waypointsetup
  local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
  AddPointToGpsMultiRoute(fillcoords.DeliveryPoint.x, fillcoords.DeliveryPoint.y, fillcoords.DeliveryPoint.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  ----------Delivery Setup------------
  --Handles the spawning of npc to "Collect Oil"
  local model = GetHashKey('rcsp_dutch3_males_01') --sets the model
  RequestModel(model) --requests the model makes it load
  while not HasModelLoaded(model) or HasModelLoaded(model) == 0 or model == 1 do
    Citizen.Wait(1)
  end
  local createdped = CreatePed(model, fillcoords.NpcSpawn.x, fillcoords.NpcSpawn.y, fillcoords.NpcSpawn.z - 1, fillcoords.NpcSpawn.h, true, true, true, true) --spawns the ped as networked so everyone can see him
  Citizen.InvokeNative(0x283978A15512B2FE, createdped, true) -- sets ped into random outfit, stops it being invis
  SetEntityInvincible(createdped, true) --sets ped invincible to prevent bugs
  FreezeEntityPosition(createdped, true) --freezes the ped in place (will only unfreeze once wagon is detected as close by the loop below, this is done to create more immersion instead of the ped just spawning when you get there)
  while true do --creates a while true do loop
    Citizen.Wait(30) --waits 30 ms
    if Playerdead == true or WagonDestroyed == true then --if player is dead or wagon broke
      deadcheck = true break --sets variable to true and breaks loop
    end
    local wc = GetEntityCoords(Createdwagon) --gets the wagons coords
    if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, fillcoords.DeliveryPoint.x, fillcoords.DeliveryPoint.y, fillcoords.DeliveryPoint.z, false) < 3 then break end --checks dist if you come within 3 of the coord then breaks loop (saves rss, and allows the code below the loop to run)
  end
  if deadcheck == true then --if deadcheck is true then(else it will just ignore this if)
    DeletePed(createdped) --deletes ped
    RemoveBlip(blip2) --removes blip
    ClearGpsMultiRoute() --clears gps
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns(return breaks loop here ending the mission/function)
  end
  FreezeEntityPosition(createdped, false) --unfreezes the ped so he can then move properly in the code below
  FreezeEntityPosition(Createdwagon, true) --freezes the wagon in place
  RemoveBlip(blip2) --removes the blip
  ClearGpsMultiRoute() --removes the waypoint
  --Hanldes what the npc will do once spawned
  TaskGoToEntity(createdped, Createdwagon, -1, 1.0, 5.0, 1073741824, 1) --(pulled from legacy_medic) makes the ped walk until it is within a distance of 2
  while true do --creates a while true do loop
    --Loop will be used to tell when the ped is near the wagon, and when he is it will break the loop allowing the code below the loop to run
    Citizen.Wait(0) --waits 10 ms to prevent crashing
    local cp = GetEntityCoords(createdped) --gets the ped coords
    local cw = GetEntityCoords(Createdwagon) --gets the wagons coords
    if GetDistanceBetweenCoords(cp.x, cp.y, cp.z, cw.x, cw.y, cw.z, true) <= 4 then break end --if the dist between the ped and wagon is less than or equal to 3 then break and end loop so code below while true do can run
  end
  TaskStartScenarioInPlace(createdped, GetHashKey('WORLD_PLAYER_CHORES_BUCKET_PUT_DOWN_FULL'), Config.OilWagonFillTime, true, false, false, false) --triggers anim
  progressbar.start(Config.Language.UnloadingOil, Config.OilWagonFillTime, function() --creates a progress bar that shows
  end, 'circle') --part of progressbar
  Citizen.Wait(Config.OilWagonFillTime) --makes it wait the time to fill the wagon(so the progress bar can finish before the code continue)
  if Progressbardeadcheck == true then --if you or wagon die then (this will run once after the progress bar so if you die during progress bar it will still continue until this runs)
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
    Progressbardeadcheck = false --resets variable so you can do a new mission
    ClearPedTasksImmediately(createdped) --clears the peds tasks
    DeletePed(createdped) --deletes the ped
    DeleteEntity(Createdwagon) return --deletes wagon in the dead check function(return will end the function here preventing the code below from running(creating a mission fail))
  end
  ClearPedTasksImmediately(createdped) --clears anim from ped
  FreezeEntityPosition(Createdwagon, false) --Unfreezes The Wagon
  VORPcore.NotifyRightTip(Config.Language.OilDelivered, 4000) --prints on screen
  --------------------This will handle the despawning of the ped, and the return wagon mission---------------------------
  --This is the blip setup/waypoint/notify for the return part of the mission
  VORPcore.NotifyRightTip(Config.Language.ReturnOilWagon, 4000)
  --Deliver Point Blip
  local oilbl = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5) --creates a blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip2, Config.Language.ReturnBlip) --names the blip
  --Waypointsetup
  local ul2 = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul2.x, ul2.y, ul2.z) --playerscoords
  AddPointToGpsMultiRoute(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  while true do --loop for ped deletion
    --Deletion of the oil collector ped
    local cp = GetEntityCoords(createdped) --gets the ped coords
    local cw = GetEntityCoords(Createdwagon) --gets the wagons coords
    Citizen.Wait(1500) --will wait 1.5 seconds before running the loop again
    if Playerdead == true or WagonDestroyed == true then --if you or wagon dead then
      deadcheck = true break --sets variable to true breaks loop
    end
    if GetDistanceBetweenCoords(cw.x, cw.y, cw.z, cp.x, cp.y, cp.z, true) > 70 or Playerdead == true or WagonDestroyed == true then --if the wagon is more than 70 away then or if you die or wagon destroyed
      DeletePed(createdped) break --deletes the ped and breaks the loop to allow code below to run
    end
  end
  if deadcheck == true then --if true then
    RemoveBlip(oilbl) --deletes blip
    ClearGpsMultiRoute() --removes waypoint
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen return ends function here acting as misison fail
  end
  ---------This will handle the returning of wagon and collection of pay--------
  while true do --this loop will freeze the wagon in place if you are near the starting point and then break loop to allow code below to run
    Citizen.Wait(30) --waits 30 ms and prevents crashing
    if Playerdead == true or WagonDestroyed == true then --if you or wagon dead then
      deadcheck = true break --set variable true and break loop
    end
    local wc = GetEntityCoords(Createdwagon) --gets wagons coords
    if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z) < 5 then --If the coords between the wagon, and those coords is less than 5 then(this is used to see if you are back at the oil company)
      TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
      FreezeEntityPosition(Createdwagon, true) --freezes it in place so you can not move it(breaks loop so the code below the loop can run)
      RemoveBlip(oilbl) --removes the blip
      ClearGpsMultiRoute() break --clears the gps waypoint and breaks loop so code below can run
    end
  end
  if deadcheck == true then --if variable true then
    RemoveBlip(oilbl) --removes blip
    ClearGpsMultiRoute() --clears gps
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen then returns and ends function here failing mission
  end
  VORPcore.NotifyRightTip(Config.Language.CollectOilDeliveryPay, 4000) --will print on screen
  while true do --this loop will check if the player gets near the oil company manager and if so will delete the wagon, and create a prompt group to collect pay
    Citizen.Wait(30) --waits to prevent crashing
    if Playerdead == true or WagonDestroyed == true then --if you or wagon is dead then
      deadcheck = true break --sets variable true and breaks loop
    end
    local pl = GetEntityCoords(PlayerPedId()) --gets players coordinates
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, true) < 3 then break --if you are less than 3 distance from the manager then it breaks loop so code below the loop can run
    end
  end
  if deadcheck == true then --if variable true then
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen, then returns ending function here and failing misison
  end
  DeleteEntity(Createdwagon) --deletes the wagon
  VORPcore.NotifyRightTip(Config.Language.ThankYouHeresYourPayOil, 4000) --prints on screen
  TriggerServerEvent('bcc:oil:PayoutOilMission', Wagon) --triggers the server event to add the money to your character(event uses the level system to add money depending on level)
  TriggerServerEvent('bcc:oil:WagonHasLeftSpawn') --triggers the server event to allow wagons to spawn again (if this is not here no wagons will be able to spawn even though the players wagon has been deleted)
  Inmission = false --sets var false allowing player to start a new mission
end

----------------------------Oil Mission Tables----------------------
OilWagonTable = {} --creates the table
OilWagonTable.ManagerSpawn = {x = 498.05, y = 672.98, z = 121.04, h = 73.92} --This is where the manager npc will spawn(Do not change!!)
OilWagonTable.WagonSpawnCoords = {x = 509.52, y = 694.24, z = 115.8, h = 263.92} --this is the x y z and heaing where the wagons will spawn

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