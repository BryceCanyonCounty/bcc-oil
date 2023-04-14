--[[##############################################################################################################################]]
--------------------------------------------Handles Spawning of Wagons and dist from spawn check -----------------------------------
----------------------------------------------Also Handles setting peds to ignore player if within dist of oil co--------------------
--[[###############################################################################################################################]]
---Spawns the wagon and triggers mission functions
Createdwagon = 0 --creates a variable only accessible by this file set to 0 (will be used to spawn the wagon, and dist check it)is global so all of client can pull it once spawned
local sw = OilWagonTable.WagonSpawnCoords --sets variable to smaller one I am lazy lmao
Wagon = 0 --creates a global variable which is used in other parts of the code
RegisterNetEvent('bcc:oil:PlayerWagonSpawn') --creates a event
AddEventHandler('bcc:oil:PlayerWagonSpawn', function(wagon) --makes the event have code to run and recieves wagon var from the server
  Inmission = true --sets the global var too true preventing a new mission from being started
  Wagon = wagon --global equals the variable from server
  modelload(Wagon) --triggers the function to load the wagon
  VORPcore.NotifyRightTip(Config.Language.WagonSpawned, 4000) --prints on screen
  Createdwagon = CreateVehicle(wagon, sw.x, sw.y, sw.z, sw.h, true, true) --spawns the wagon
  Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Createdwagon, 1, 0)
  TriggerEvent('bcc:oil:PlayerWagonDistFromSpawnCheck')
  if wagon == 'oilwagon02x' then --if variable = text then
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck') --triggers dead check event from below(has to be triggered as an event triggering it as function would cause it not to run the function below)
    beginningstage() --triggers function
  elseif wagon == 'armysupplywagon' then --elseif variable = this then
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck') --triggers the dead check event from below
    supplymissionbeginstage() --triggers function
  end
end)

---------------Creates a client event to check distance the wagon is from spawn coords/if it is disable wagons from spawning/if it isnt allow wagons to spawn again ----------------------
--This is so that players cant spam wagons on top of each other
RegisterNetEvent('bcc:oil:PlayerWagonDistFromSpawnCheck')
AddEventHandler('bcc:oil:PlayerWagonDistFromSpawnCheck', function()
  local isnear = false --creates catch variable
  local isntnear = false --creates catch variable
  while true do --creates a while true do loop
    Citizen.Wait(1000) --Waits 1 second(prevents crashing, and performance loss)
    if WagonDestroyed == false and Playerdead == false then --if both variables are false(if you and the wagon are both alive) then
      local wagoncoords = GetEntityCoords(Createdwagon) --gets wagons coords
      local dist = GetDistanceBetweenCoords(sw.x, sw.y, sw.z, wagoncoords.x, wagoncoords.y, wagoncoords.z, false) --gets distance between the 2 coordinates and does not include the z value
      local wce = DoesEntityExist(Createdwagon) --checks if the entity exists still
      if wce == 1 then --if entity exists then
        if dist > 20 then --if dist greater than 20 then
          if isntnear == false then --if isnt near = false then(if this hasnt run or elseif below changed it back to false)
            isntnear = true --sets variable to true so that this wont run again unless changed
            isnear = false --sets isnear to false so the elseif can run
            TriggerServerEvent('bcc:oil:WagonHasLeftSpawn') --triggers server event that will change the dist catch variable back(allowing more wagons to spawn)
          end
          --the isnear and isntnear boolean if statements are used to check throughout the whole mission if the wagon is near spawn and if it is then disable anyone else from spawning a wagon elseif your not near the spawn then allow wagon spawning again(prevents abuse and bugs from multiple people spawning wagons at once)
        elseif dist < 20 then --if dist greater than 20 then
          if isnear == false then --if isnear = false(this hasnt ran yet or the if above changed the variable back to false then)
            isnear = true --sets this variable to true so this code cant run again unless the if above changes it back to false
            isntnear = false --resets the variable so the above if can run again if the wagon comes back to the spawn
            TriggerServerEvent('bcc:oil:WagonHasArrivedInSpawn') --triggers the event to make it so wagons cant spawn again (prevent being able to leave spawn and come back to spawn another wagon, also prevents wagons from spawning again when returning the wagon)
          end
        end
      end
    elseif WagonDestroyed == true or Playerdead == true then --if either variable = true (you or the wagon is dead or if wagond doesnt exist) then
      DeleteEntity(Createdwagon) --will delete the wagon
      Wait(1000) --waits 1 second to give other parts of code time to adjust
      WagonDestroyed = false --you have to reset to false other wise it will insta fail and the player will have to leave and rejoin server before being able to start  new mission
      Playerdead = false --same as above variable
      TriggerServerEvent('bcc:oil:WagonHasLeftSpawn')
      Citizen.Wait(Config.OilWagonFillTime + 5000) --waits the set time in config(this is necessary otherwise if you do not die while in a progressbar say you die on your way to deliver the progressbar variable still gets set true and will insta fail as soon as you fill the wagon with oil)
      Progressbardeadcheck = false break --sets variable to false then breaks loop
    end
  end
end)

--------Creates a client event that will be used throughout the whole of both wagon missions too see if you or the wagon is dead and if so change variable to true to stop the missions----
Playerdead = false --global variable to be used between all client scripts. Used as a catch so if it is set to true end mission
WagonDestroyed = false --same as above variable
Progressbardeadcheck = false --variable used for deadchecking in progressbar areas of code(this variable wont be reset by this file unlike the other 2 allowing it too be the catch for anything not in a loop (if the other 2 variables are used outside of a loop it wont work as they reset to fast this variable is to be reset anywhere it is used in other files))
RegisterNetEvent('bcc-oil:WagonDeliveriesDeadCheck')
AddEventHandler('bcc-oil:WagonDeliveriesDeadCheck', function()
  while true do --creates a loop that will run until broken
    Citizen.Wait(60) --waits 60ms reduces lag by increased time
    local pdead = IsEntityDead(PlayerPedId()) --checks if player is dead false if alive 1 if dead
    local wdestroyed = GetEntityHealth(Createdwagon) --checks the wagons hp spawn hp is 1000, if it is destroyed hp is 0
    local cwexist = DoesEntityExist(Createdwagon) --checks if entity exists if so prints 1 if not prints false
    if wdestroyed == 0 or cwexist == false or pdead == 1 then --if wagon is destroyed or doesnt exist then(doesnt exist is needed for when you complete the mission)
      Inmission = false --resets the var allowing a new mission to start
      Progressbardeadcheck = true --sets variable too true allowing other parts of the code to know you died
      WagonDestroyed = true --changes variable and breaks loop(variable change makes it so the mission can end when destroyed)
      Playerdead = true break
    end
  end
end)