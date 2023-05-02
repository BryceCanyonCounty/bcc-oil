------- Oil Wagon Robbery Setup -----
Robableoilwagon = 0 --this variable is used to store the created wagon in (this is needed as the wagon is deleted in a seperate function so that function has to access it)
Roboilwagondeadcheck = false --this functions as a dead check so if true then break etc
local fillcoords = nil --creates a variable used to pick a random table
local mathr1 = 0 --this is used to select a random table from config
RegisterNetEvent('bcc-oil:RobOilWagon', function()
  --variables
  Inmission = true --sets the variable too true(which will when true no allow the nui menu to be used to trigger a new function)
  
  --Loading Wagon Model
  Robableoilwagon = 'oilwagon02x' --sets the variable to the string wagon hash
  modelload(Robableoilwagon) --triggers the function to load the model

  --Coord Randomization
  mathr1 = math.random(1, #Config.OilWagonrobberyLocations) --Gets a random set of coords from OilWagontable.FillPoints
  fillcoords = Config.OilWagonrobberyLocations[mathr1] --gets a random set of coords from OilWagonTable.FillPoints
  
  --Wagon Spawn
  Robableoilwagon = CreateVehicle(Robableoilwagon, fillcoords.wagonlocation.x, fillcoords.wagonlocation.y, fillcoords.wagonlocation.z, fillcoords.wagonlocation.h, true, true) --creates the oilwagon at the location and sets it too the variable so it can be used in a net event
  TriggerEvent('bcc-oil:roboilwagonhelper') --triggers the event that will check if you die during the misison
  Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, Robableoilwagon) --sets the blip that tracks the ped
  FreezeEntityPosition(Robableoilwagon, true) --freezes the wagon in place
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonOpeningtext, 4000) --prints on screen
  
  --Waypoint Setup
  VORPutils.Gps:SetGps(fillcoords.wagonlocation.x, fillcoords.wagonlocation.y, fillcoords.wagonlocation.z) --Creates the gps waypoint

  --Distance Check Setup
  local cw = GetEntityCoords(Robableoilwagon)
  distcheck(cw.x, cw.y, cw.z, 30, PlayerPedId())
  if Roboilwagondeadcheck then --if variable true then (if your dead or wagon destroyed)
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
    DeleteEntity(Robableoilwagon) --deletes the wagon
    VORPutils.Gps:RemoveGps() return --clears your gps and returns ending the function here
  end
  VORPutils.Gps:RemoveGps() --clears your gps
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonKillGaurds, 4000) --prints on screen

  --Spawning enemy Peds
  MutltiPedSpawnDeadCheck(fillcoords.pedlocation, 'wagonrob') --triggers the function to spawn multiple peds with a deadcheck
end)

function roboilwagonreturnwagon()
  --Init Setup
  FreezeEntityPosition(Robableoilwagon, false) --unfreezes the wagon
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonReturnWagon, 4000) --prints on screen
  
  --Blip and Waypoint Setup
  local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z, 5) --creates blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.RobOilWagonReturnBlip) --names blip
  VORPutils.Gps:SetGps(fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z) --Creates the gps waypoint

  --Distance Check Setup for returning the wagon
  distcheck(fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z, 10, Robableoilwagon)
  if Roboilwagondeadcheck then --if varibale true then (if you die or wagon broke)
    VORPutils.Gps:RemoveGps() --clears your gps and returns ending the function here
    RemoveBlip(blip1) --removes blip
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
    DeleteEntity(Robableoilwagon) return --deletes the wagon then returns ending the function here not allowing the code below to run
  end

  --End of mission setup
  Inmission = false --sets variable too false allowing you too do another misison
  FreezeEntityPosition(Robableoilwagon, true) --freezes the wagon
  RemoveBlip(blip1) --removes blip
  VORPutils.Gps:RemoveGps() --clears your gps and returns ending the function here
  TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
  Wait(4000) --waits 4 seconds
  DeleteEntity(Robableoilwagon) --deletes the wagon
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonSuccess, 4000) --prints on screen
  TriggerServerEvent('bcc-oil:RobberyPayout') --triggers server event and passes variable (this is what pays you)
end

--Deadcheck event
AddEventHandler('bcc-oil:roboilwagonhelper', function() --makes the event have code to run
  Wait(400) --gives the script some breathign room
  while Inmission do --while true do loop wont break until broken
    Citizen.Wait(80) --waits 80ms prevents crashing
    local pdead = IsEntityDead(PlayerPedId()) --sets variable to if your dead
    local whealth = GetEntityHealth(Robableoilwagon) --sets variable to the wagons health
    local wexist = DoesEntityExist(Robableoilwagon) --sets variable too if the wagon exists
    if pdead == 1 or whealth == 0 or wexist == false then --if any are true then (if anything has been killed)
      Roboilwagondeadcheck = true --sets var to true
      Inmission = false --sets var too false allowing you to do another mission
      Wait(3000) --waits 3 seconds
      Roboilwagondeadcheck = false break --resets variable and breaks loop
    end
  end
end)

--Rob Oil Company Variables Setup
Roboilcodeadcheck = false --this is the var used to check if player dies during mission
local fillcoords2 = nil --creates a variable used to store data
local missionoverend3dtext = false --this var will be used to see if you finished lockpicking and if so stop showing the 3dtext
RegisterNetEvent('bcc-oil:RobOilCo', function()
  --Begining Setup
  VORPcore.NotifyRightTip(Config.Language.RobOilCoBlip, 4000) --Prints on screen
  Inmission = true --sets var true not allowing player to start another mission
  TriggerEvent('bcc-oil:roboilcohelper') --triggers the deadcheck event(has to be an event since they run async unlike functions)
  
  --Coord Randomization
  local mathr12 = math.random(1, #Config.RobOilCompany) --Gets a random set of coords from OilWagontable.FillPoints
  fillcoords2 = Config.RobOilCompany[mathr12] --gets a random set of coords from OilWagonTable.FillPoints
  
  --Blip and Waypoint Setup
  local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, 5) --creates blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.RobOilCoBlip) --names blip
  VORPutils.Gps:SetGps(fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z) --Creates the gps waypoint
  
  --Distance Check Setup for close to lockpick Location
  distcheck(fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, 5, PlayerPedId())
  if Roboilcodeadcheck then --if var is true then
    RemoveBlip(blip1) --removes blip
    VORPutils.Gps:RemoveGps() --clears your gps and returns ending the function here
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen and returns ending the function here preventing code below from running
  end
  RemoveBlip(blip1) --removes the blip
  VORPutils.Gps:RemoveGps() --clears your gps and returns ending the function here
  while true do --creates  aloop that runs until broken
    Citizen.Wait(5) --waits 80ms preventing crashing
    if IsControlJustReleased(0, 0x760A9C6F) then --if G is pressed then
      local result = exports['lockpick']:startLockpick() --starts the lockpick and sets result to equal the result will print true if done right false if failed
      if result then --if result true then (you did it right)
        if not Config.RobOilCoEnemyPeds then
          missionoverend3dtext = true --sets var true which is used to disable the 3d text from showing
          Inmission = false --resets the var allowing player to start a new misison
          VORPcore.NotifyRightTip(Config.Language.RobberySuccess, 4000) --prints on screen
          TriggerServerEvent('bcc-oil:OilCoRobberyPayout', fillcoords2) break --triggers server event and passes the variable too it breaks loop
        else --if the option is anything else
          MutltiPedSpawnDeadCheck(Config.RobOilCoEnemyPedsLocations, 'oilcorob')
          Inmission = false break --trigger function to spawn enemy peds and break loop when done
        end
      else --else if you did not do it right
        if not Config.RobOilCoEnemyPeds then
          missionoverend3dtext = true --sets var true which is used to disable the 3d text from showing
          Inmission = false --resets the var allowing player to start a new misison
          VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) break --prints on screen and breaks loop
        else --if it is true then
          MutltiPedSpawnDeadCheck(Config.RobOilCoEnemyPedsLocations, 'oilcorob') 
          Inmission = false break --spawn all the enemy peds, and when its done break the loop
        end
      end
    end
  end
end)

AddEventHandler('bcc-oil:roboilcohelper', function() --this makes the event have code to run
  while Inmission do --while true do loop wont stop until broken
    Citizen.Wait(5) --waits 80ms prevents crashing
    local pl = GetEntityCoords(PlayerPedId()) --gets players coords
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, true) < 15 then --if dist less than 15 then
      if not missionoverend3dtext then --if var is false then
        DrawText3D(fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, Config.Language.PressGToLockPick) --draws text on coords
      else --else its not false then
        missionoverend3dtext = false break --resets var and breaks loop
      end
    end
    if IsEntityDead(PlayerPedId()) then
      Inmission = false --resets the var allowing player to start a new misison
      Roboilcodeadcheck = true --set var true
      Wait(10000) --waits 10 seconds
      Roboilcodeadcheck = false --resets var so this can run again
    end
  end
end)