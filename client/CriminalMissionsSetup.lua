--[##############################Pulling essentials#######################################]
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)


--[[###################################Steal Oil Wagon Setup#############################################]]
local robableoilwagon = 0 --this variable is used to store the created wagon in (this is needed as the wagon is deleted in a seperate function so that function has to access it)
local roboilwagondeadcheck = false --this functions as a dead check so if true then break etc
local roboilwagonpeds = {} --this creates a table used too store the wagon defenders
local count = {} --this creates a table used to keep count of wagon defenders(and too see if the count alive is less than starting and if so then they are all dead proceed with the mission)
local fillcoords = nil --creates a variable used to pick a random table
local mathr1 = 0 --this is used to select a random table from config
function roboilwagon() --creates a function named roboilwagon
  Inmission = true --sets the variable too true(which will when true no allow the nui menu to be used to trigger a new function)
  local runonce = 0 --creates a variable used to only run a section of code once
  robableoilwagon = 'oilwagon02x' --sets the variable to the string wagon hash
  RequestModel(robableoilwagon) --requests the model(makes it actually spawn)
  while not HasModelLoaded(robableoilwagon) do --while the model has not loaded do
    Wait(10) --wait 10ms
  end
  mathr1 = math.random(1, #Config.OilWagonrobberyLocations) --Gets a random set of coords from OilWagontable.FillPoints
  fillcoords = Config.OilWagonrobberyLocations[mathr1] --gets a random set of coords from OilWagonTable.FillPoints
  FreezeEntityPosition(robableoilwagon, true) --freezes the wagon in place
  robableoilwagon = CreateVehicle(robableoilwagon, fillcoords.wagonlocation.x, fillcoords.wagonlocation.y, fillcoords.wagonlocation.z, fillcoords.wagonlocation.h, true, true) --creates the oilwagon at the location and sets it too the variable so it can be used in a net event
  TriggerEvent('bcc-oil:roboilwagonhelper') --triggers the event that will check if you die during the misison
  Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, robableoilwagon) --sets the blip that tracks the ped
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonOpeningtext, 4000) --prints on screen
  local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
  AddPointToGpsMultiRoute(fillcoords.wagonlocation.x, fillcoords.wagonlocation.y, fillcoords.wagonlocation.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  while true do --creates a loop that runs until broken
    Citizen.Wait(80) --waits 80ms too prevent crashing and improve performance
    if roboilwagondeadcheck then break end --if the variable is true then break the loop
    local pl = GetEntityCoords(PlayerPedId()) --sets the variable to the players coords
    local wc = GetEntityCoords(robableoilwagon) --sets the variable to the wagons coords
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, wc.x, wc.y, wc.z, true) < 30 then break end --if you are closer than 30 then break loop and allow code below loop too run
  end
  if roboilwagondeadcheck then --if variable true then (if your dead or wagon destroyed)
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
    DeleteEntity(robableoilwagon) --deletes the wagon
    ClearGpsMultiRoute() return --clears your gps
  end
  ClearGpsMultiRoute() --clears your gps
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonKillGaurds, 4000) --prints on screen
  local model = 'a_m_m_huntertravelers_cool_01' --sets variable to the string the peds hash
  if not HasModelLoaded(model) then --if model has not loaded then
    RequestModel(model) --requests the model
  end
  while not HasModelLoaded(model) do --while the modle has not loaded
    Citizen.Wait(1) --wait 1ms
  end
  for k, v in pairs(fillcoords.pedlocation) do --creates a for loop which runs once per table
    roboilwagonpeds[k] = CreatePed(model, v.x, v.y, v.z, true, true, true, true) --creates the peds and stores them in the table as the [k] key
    Citizen.InvokeNative(0x283978A15512B2FE, roboilwagonpeds[k], true) --creates a blip on each of the npcs
    TaskCombatPed(roboilwagonpeds[k], PlayerPedId()) --makes each npc fight the player
    Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, roboilwagonpeds[k]) --sets the blip that tracks the ped
    count[k] = roboilwagonpeds[k] --sets count to equal the amount of ped spawns
    if runonce == 0 then --if variable == 0 then (prevents  this running twice)
      runonce = runonce + 1 -- variable = variable + 1 prevent this from running again(essentially seperating the code)
      Citizen.CreateThread(function() --creates a thread(threads run async so this will continue too run no matter what happens outside it)
        local x = #fillcoords.pedlocation --sets x to the number of how many table there are
        while roboilwagondeadcheck == false do --while the variable is true do (while nothing has died do)
          Citizen.Wait(60) --waits 60ms prevents crashing
          for k, v in pairs(roboilwagonpeds) do --creates  for loop running once per table
            if IsEntityDead(v) then --if peds are dead then
              if count[k] ~= nil then --if variable not nil then
                x = x - 1 --x = x - 1
                count[k] = nil --sets count too nil
                if x == 0 then --if x = 0 then(all peds are dead)
                  roboilwagonreturnwagon() break --triggers function and breaks loop
                end
              end
            end
          end
        end
        if roboilwagondeadcheck then --if variable true(you or wagon are dead then)
          for k, v in pairs(roboilwagonpeds) do --creates a for loop in the peds table
            DeletePed(v) --deletes all the peds
          end
          DeleteEntity(robableoilwagon) --deletes the wagon
          VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen and returns ending this function
        end
      end)
    end
  end
end

function roboilwagonreturnwagon()
  FreezeEntityPosition(robableoilwagon, false) --unfreezes the wagon
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonReturnWagon, 4000) --prints on screen
  local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z, 5) --creates blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.RobOilWagonReturnBlip) --names blip
  local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
  AddPointToGpsMultiRoute(fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  while true do --creates  while true do loop which will run until broken
    Citizen.Wait(80) --wait 80ms prevents crashing
    if roboilwagondeadcheck then break end --if variable true then break loop (if you die or wagon broke)
    local wc = GetEntityCoords(robableoilwagon) --sets variable to the wagons coordinates
    if GetDistanceBetweenCoords(wc.x, wc.y, wc.z, fillcoords.returnlocation.x, fillcoords.returnlocation.y, fillcoords.returnlocation.z, true) < 10 then break end --if wagon is closer than 10 to the location break loop allowing code below the loop to run
  end
  if roboilwagondeadcheck then --if varibale true then (if you die or wagon broke)
    ClearGpsMultiRoute() --clears gps
    RemoveBlip(blip1) --removes blip
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) --prints on screen
    DeleteEntity(robableoilwagon) return --deletes the wagon then returns ending the function here not allowing the code below to run
  end
  FreezeEntityPosition(robableoilwagon, true) --freezes the wagon
  RemoveBlip(blip1) --removes blip
  ClearGpsMultiRoute() --clears gps
  TaskLeaveAnyVehicle(PlayerPedId(), 0, 0) --makes the player get off the wagon
  Wait(4000) --waits 4 seconds
  DeleteEntity(robableoilwagon) --deletes the wagon
  VORPcore.NotifyRightTip(Config.Language.RobOilWagonSuccess, 4000) --prints on screen
  TriggerServerEvent('bcc-oil:RobberyPayout') --triggers server event and passes variable (this is what pays you)
  Inmission = false --sets variable too false allowing you too do another misison
end
--Deadcheck event
RegisterNetEvent('bcc-oil:roboilwagonhelper') --creates an event with that name
AddEventHandler('bcc-oil:roboilwagonhelper', function() --makes the event have code to run
  Wait(400) --gives the script some breathign room
  while true do --while true do loop wont break until broken
    Citizen.Wait(80) --waits 80ms prevents crashing
    local pdead = IsEntityDead(PlayerPedId()) --sets variable to if your dead
    local whealth = GetEntityHealth(robableoilwagon) --sets variable to the wagons health
    local wexist = DoesEntityExist(robableoilwagon) --sets variable too if the wagon exists
    if pdead == 1 or whealth == 0 or wexist == false then --if any are true then (if anything has been killed)
      roboilwagondeadcheck = true --sets var to true
      Inmission = false --sets var too false allowing you to do another mission
      Wait(3000) --waits 3 seconds
      roboilwagondeadcheck = false break --resets variable and breaks loop
    end
  end
end)


local roboilcodeadcheck = false --this is the var used to check if player dies during mission
local fillcoords2 = nil --creates a variable used to store data
local missionoverend3dtext = false --this var will be used to see if you finished lockpicking and if so stop showing the 3dtext
function roboilco() --creates a function
  VORPcore.NotifyRightTip(Config.Language.RobOilCoBlip, 4000)
  Inmission = true --sets var true not allowing player to start another mission
  TriggerEvent('bcc-oil:roboilcohelper') --triggers the deadcheck event(has to be an event since they run async unlike functions)
  local mathr12 = math.random(1, #Config.RobOilCompany) --Gets a random set of coords from OilWagontable.FillPoints
  fillcoords2 = Config.RobOilCompany[mathr12] --gets a random set of coords from OilWagonTable.FillPoints
  local blip1 = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, 5) --creates blip using natives
  Citizen.InvokeNative(0x9CB1A1623062F402, blip1, Config.Language.RobOilCoBlip) --names blip
  --Waypointsetup
  local ul = GetEntityCoords(PlayerPedId()) --gets players location(not needed if alreadysetup)
  StartGpsMultiRoute(6, true, true) --sets the color and tells it to waypoint on foot and in vehicle
  AddPointToGpsMultiRoute(ul.x, ul.y, ul.z) --playerscoords
  AddPointToGpsMultiRoute(fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z) --Where the waypoint is set too
  SetGpsMultiRouteRender(true) --sets the waypoint to active
  while true do --creates a while true do loop which will run until broken
    Citizen.Wait(80) --waits 80ms prevents crashing
    if roboilcodeadcheck then break end --if player is dead then breaks loop
    local pl = GetEntityCoords(PlayerPedId()) --gets players coords
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, true) < 5 then break end --if player is closer than 5 to the coords then break the loop
  end
  if roboilcodeadcheck then --if var is true then
    RemoveBlip(blip1) --removes blip
    ClearGpsMultiRoute() --clears gps
    VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen and returns ending the function here preventing code below from running
  end
  RemoveBlip(blip1) --removes the blip
  ClearGpsMultiRoute() --clears gps
  while true do --creates  aloop that runs until broken
    Citizen.Wait(5) --waits 80ms preventing crashing
    if IsControlJustReleased(0, 0x760A9C6F) then --if G is pressed then
      local result = exports['lockpick']:startLockpick() --starts the lockpick and sets result to equal the result will print true if done right false if failed
      if result then --if result true then (you did it right)
        Wait(200) --waits 200ms gives code breathing room(these waits seemed to fix some nui callback errors. If you failed the lockpick then tried to steal a oil wagon it would give a nui error these seem to fix that)
        missionoverend3dtext = true --sets var true which is used to disable the 3d text from showing
        Inmission = false --resets the var allowing player to start a new misison
        VORPcore.NotifyRightTip(Config.Language.RobberySuccess, 4000) --prints on screen
        TriggerServerEvent('bcc-oil:OilCoRobberyPayout', fillcoords2) break --triggers server event and passes the variable too it breaks loop
      else --else if you did not do it right
        Wait(200) --waits 200ms gives code breathing room(these waits seemed to fix some nui callback errors. If you failed the lockpick then tried to steal a oil wagon it would give a nui error these seem to fix that)
        missionoverend3dtext = true --sets var true which is used to disable the 3d text from showing
        Inmission = false --resets the var allowing player to start a new misison
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) break --prints on screen and breaks loop
      end
    end
  end
end

RegisterNetEvent('bcc-oil:roboilcohelper') --this creates a event
AddEventHandler('bcc-oil:roboilcohelper', function() --this makes the event have code to run
  while true do --while true do loop wont stop until broken
    Citizen.Wait(5) --waits 80ms prevents crashing
    local pl = GetEntityCoords(PlayerPedId()) --gets players coords
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, true) < 15 then --if dist less than 15 then
      if not missionoverend3dtext then --if var is false then
        DrawText3D(fillcoords2.lootlocation.x, fillcoords2.lootlocation.y, fillcoords2.lootlocation.z, Config.Language.PressGToLockPick) --draws text on coords
      else --else its not false then
        missionoverend3dtext = false break --resets var and breaks loop
      end
    end
    if IsEntityDead(PlayerPedId()) == 1 then --if player is dead then
      Inmission = false --resets the var allowing player to start a new misison
      roboilcodeadcheck = true break --set var true and break loop
    end
  end
end)