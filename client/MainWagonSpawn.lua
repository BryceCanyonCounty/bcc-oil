------ Handles spawning the wagons -----
Createdwagon, Wagon = 0, 0
local sw = OilWagonTable.WagonSpawnCoords
RegisterNetEvent('bcc:oil:PlayerWagonSpawn', function(wagon)
  Inmission = true --sets the global var too true preventing a new mission from being started
  Wagon = wagon --global equals the variable from server
  modelload(Wagon) --triggers the function to load the wagon
  VORPcore.NotifyRightTip(Config.Language.WagonSpawned, 4000) --prints on screen
  Createdwagon = CreateVehicle(wagon, sw.x, sw.y, sw.z, sw.h, true, true) --spawns the wagon
  Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Createdwagon, 1, 0)
  TriggerEvent('bcc:oil:PlayerWagonDistFromSpawnCheck')
  local wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, Createdwagon) -- Add wagon blip
  SetBlipScale(wagonBlip, 0.8) --sets wagon blip scale
  if wagon == 'oilwagon02x' then --if variable = text then
    SetBlipSprite(wagonBlip, Config.OilWagonBilpHash, 1) -- sets oil wagon blip icon
    Citizen.InvokeNative(0x662D364ABF16DE2F, wagonBlip, joaat(Config.OilWagonBlipColor))  --Sets oil wagon blip color
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, Config.Language.OilWagonBlipName) -- Sets oil wagon blip name
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck') --triggers dead check event from below(has to be triggered as an event triggering it as function would cause it not to run the function below)
    beginningstage() --triggers function
  elseif wagon == 'armysupplywagon' then --elseif variable = this then
    SetBlipSprite(wagonBlip, Config.SupplyWagonBilpHash, 1) -- sets supply wagon blip icon
    Citizen.InvokeNative(0x662D364ABF16DE2F, wagonBlip, joaat(Config.SupplyWagonBlipColor))  --Sets supply wagon blip color
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, Config.Language.SupplyWagonBlipName) -- Sets supply wagon blip name
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck') --triggers the dead check event from below
    supplymissionbeginstage() --triggers function
  end
end)

---------------Creates a client event to check distance the wagon is from spawn coords/if it is disable wagons from spawning/if it isnt allow wagons to spawn again ----------------------
AddEventHandler('bcc:oil:PlayerWagonDistFromSpawnCheck', function()
  local isnear, isntnear = false, false
  while true do
    Wait(1000)
    if WagonDestroyed == false and Playerdead == false then
      local wagoncoords = GetEntityCoords(Createdwagon)
      if DoesEntityExist(Createdwagon) then
        if GetDistanceBetweenCoords(sw.x, sw.y, sw.z, wagoncoords.x, wagoncoords.y, wagoncoords.z, false) > 20 then --if dist greater than 20 then
          if not isntnear then
            isntnear = true --sets variable to true so that this wont run again unless changed
            isnear = false --sets isnear to false so the elseif can run
            TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
          end
        else
          if not isnear then --if isnear = false(this hasnt ran yet or the if above changed the variable back to false then)
            isnear = true --sets this variable to true so this code cant run again unless the if above changes it back to false
            isntnear = false --resets the variable so the above if can run again if the wagon comes back to the spawn
            TriggerServerEvent('bcc-oil:WagonInSpawnHandler', true)
          end
        end
      end
    else
      DeleteEntity(Createdwagon) --will delete the wagon
      Wait(1000) --waits 1 second to give other parts of code time to adjust
      WagonDestroyed = false --you have to reset to false other wise it will insta fail and the player will have to leave and rejoin server before being able to start  new mission
      Playerdead = false --same as above variable
      TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
      Wait(Config.OilWagonFillTime + 5000)
      Progressbardeadcheck = false break --sets variable to false then breaks loop
    end
  end
end)

--------Creates a client event that will be used throughout the whole of both wagon missions too see if you or the wagon is dead and if so change variable to true to stop the missions----
Playerdead, WagonDestroyed, Progressbardeadcheck = false, false, false
AddEventHandler('bcc-oil:WagonDeliveriesDeadCheck', function()
  while true do
    Wait(100)
    if GetEntityHealth(Createdwagon) == 0 or DoesEntityExist(Createdwagon) == false or IsEntityDead(PlayerPedId()) == 1 then
      Inmission = false --resets the var allowing a new mission to start
      Progressbardeadcheck = true --sets variable too true allowing other parts of the code to know you died
      WagonDestroyed = true --changes variable and breaks loop(variable change makes it so the mission can end when destroyed)
      Playerdead = true break
    end
  end
end)