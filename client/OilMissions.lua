local T = Translation.Langs[Config.Lang]

--------------------------------------- Pulling Essentials -------------------------------------------
progressbar = exports.vorp_progressbar:initiate() --Allows use of progressbar in code

----- Oil Delivery Setup -----
function beginningstage()
  Wait(1000)
  Notify(0, T.FillYourOilWagon, 'info')
  -- VORPcore.NotifyRightTip(T.FillYourOilWagon, 4000)
  local fillcoords = CoordRandom(OilWagonTable.FillPoints)

  --Blip and Waypoint setup
  local blip1 = BlipWaypoin(fillcoords.fillpoint.x, fillcoords.fillpoint.y, fillcoords.fillpoint.z, T.FillBlipName)

  -------------Dist Check for fill Setup-----------------
  distcheck(fillcoords.fillpoint.x, fillcoords.fillpoint.y, fillcoords.fillpoint.z, 3, Createdwagon)
  ClearGpsMultiRoute()
  if Playerdead or WagonDestroyed then
    RemoveBlip(blip1)
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail') return
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
  end
  FreezeEntityPosition(Createdwagon, true)
  RemoveBlip(blip1)

  -------Progress bar / Fill Wagon Setup----------
  TaskLeaveAnyVehicle(PlayerPedId(), 0, 0)
  Notify(0, T.FillingOilwagon, 'info')
  -- VORPcore.NotifyRightTip(T.FillingOilwagon, 4000)
  Wait(3000)
  SetEntityHeading(PlayerPedId(), GetEntityHeading(Createdwagon))
  Wait(500)
  TaskStartScenarioInPlace(PlayerPedId(), joaat('WORLD_CAMP_JACK_ES_BUCKET_POUR'), Config.OilWagonFillTime, true, false, false, false)
  progressbar.start(T.FillingOilwagon, Config.OilWagonFillTime, function()
  end, 'circle')
  Wait(Config.OilWagonFillTime)
  if Progressbardeadcheck then
    Progressbardeadcheck = false
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail')
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000)
    DeleteEntity(Createdwagon) return
  end
  ClearPedTasksImmediately(PlayerPedId())
  TaskEnterVehicle(PlayerPedId(), Createdwagon, 4000, -1, 0)
  deliveroil()
end

-----------------------Deliver oil Mission&return wagon included here------------------------------
function deliveroil()
  FreezeEntityPosition(Createdwagon, false)
  TriggerServerEvent('bcc-oil:ManageStep')
  Wait(200)
  Notify(0, T.GoDeliver, 'info')
  -- VORPcore.NotifyRightTip(T.GoDeliver, 4000)

  --Coord Randomization
  local fillcoords = CoordRandom(Config.OilDeliveryPoints)

  --Blip and Waypoint Setup
  local blip2 = BlipWaypoin(fillcoords.DeliveryPoint.x, fillcoords.DeliveryPoint.y, fillcoords.DeliveryPoint.z, T.DeliverBlipName)

  --Spawning Ped Setup
  local model = joaat('rcsp_dutch3_males_01')
  modelload(model)
  local createdped = CreatePed(model, fillcoords.NpcSpawn.x, fillcoords.NpcSpawn.y, fillcoords.NpcSpawn.z - 1, fillcoords.NpcSpawn.h, true, true, true, true)
  Citizen.InvokeNative(0x283978A15512B2FE, createdped, true)
  SetEntityInvincible(createdped, true)
  FreezeEntityPosition(createdped, true)

  --Distance Check Setup wagon to delivery point
  distcheck(fillcoords.DeliveryPoint.x, fillcoords.DeliveryPoint.y, fillcoords.DeliveryPoint.z, 3, Createdwagon)
  ClearGpsMultiRoute()
  if Playerdead or WagonDestroyed then
    DeletePed(createdped)
    RemoveBlip(blip2)
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail') return
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
  end
  FreezeEntityPosition(createdped, false)
  FreezeEntityPosition(Createdwagon, true)
  RemoveBlip(blip2)

  --Distance Check Setup Ped To Wagon
  TaskGoToEntity(createdped, Createdwagon, -1, 1.0, 5.0, 1073741824, 1) --(pulled from legacy_medic)
  local cw = GetEntityCoords(Createdwagon)
  distcheck(cw.x, cw.y, cw.z, 5, createdped)

  --Filling Up Setup
  TaskStartScenarioInPlace(createdped, joaat('WORLD_PLAYER_CHORES_BUCKET_PUT_DOWN_FULL'), Config.OilWagonFillTime, true, false, false, false)
  progressbar.start(T.UnloadingOil, Config.OilWagonFillTime, function()
  end, 'circle')
  Wait(Config.OilWagonFillTime)
  if Progressbardeadcheck then
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000)
    Notify(0, T.Missionfailed, 'fail')
    TriggerServerEvent('bcc-oil:cancelMission')
    Progressbardeadcheck = false
    ClearPedTasksImmediately(createdped)
    DeletePed(createdped)
    DeleteEntity(Createdwagon) return
  end
  ClearPedTasksImmediately(createdped)
  FreezeEntityPosition(Createdwagon, false)
  -- VORPcore.NotifyRightTip(T.OilDelivered, 4000)
  Notify(0, T.OilDelivered, 'success')
  -- VORPcore.NotifyRightTip(T.ReturnOilWagon, 4000)
  Notify(0, T.ReturnOilWagon, 'info')
  TriggerServerEvent('bcc-oil:ManageStep')

  --------------------This will handle the despawning of the ped, and the return wagon mission---------------------------
  --Waypoint and Blip Setup
  local oilbl = BlipWaypoin(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, T.ReturnBlip)

  --Distance Check setup for deleting ped
  local pedcoord = GetEntityCoords(createdped)
  distcheck(pedcoord.x, pedcoord.y, pedcoord.z, 70, Createdwagon)
  if Playerdead or WagonDestroyed then
    RemoveBlip(oilbl)
    ClearGpsMultiRoute()
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail') return
  end


  --Dist Check for returning wagon
  distcheck(OilWagonTable.WagonSpawnCoords.x, OilWagonTable.WagonSpawnCoords.y, OilWagonTable.WagonSpawnCoords.z, 5, Createdwagon)
  ClearGpsMultiRoute()
  if Playerdead or WagonDestroyed then
    RemoveBlip(oilbl)
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail') return
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
  end
  TaskLeaveAnyVehicle(PlayerPedId(), 0, 0)
  FreezeEntityPosition(Createdwagon, true)
  RemoveBlip(oilbl)
  -- VORPcore.NotifyRightTip(T.CollectOilDeliveryPay, 4000)
  Notify(0, T.CollectOilDeliveryPay, 'info')

  --Distance Check for Player To Manager Ped
  distcheck(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, 3, PlayerPedId())
  if Playerdead or WagonDestroyed then
    DeleteEntity(Createdwagon)
    TriggerServerEvent('bcc-oil:cancelMission')
    Notify(0, T.Missionfailed, 'fail') return
    -- VORPcore.NotifyRightTip(T.Missionfailed, 4000) return
  end
  DeleteEntity(Createdwagon)
  Notify(0, T.ThankYouHeresYourPayOil, 'success')
  -- VORPcore.NotifyRightTip(T.ThankYouHeresYourPayOil, 4000)
  TriggerServerEvent('bcc:oil:PayoutOilMission')
  TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
  Inmission = false
end

---------- Sniffing Oil Setup ---------------
CreateThread(function()
  if Config.SniffOil.enable then
    while true do
      Wait(5)
      local plc = GetEntityCoords(PlayerPedId())
      local dist = GetDistanceBetweenCoords(plc.x, plc.y, plc.z, Config.SniffOil.Coords.x, Config.SniffOil.Coords.y, Config.SniffOil.Coords.z, true)
      if dist < 3 then
        BccUtils.Misc.DrawText3D(Config.SniffOil.Coords.x, Config.SniffOil.Coords.y, Config.SniffOil.Coords.z, T.SniffOil)
        if IsControlJustReleased(0, 0x760A9C6F) then
          AnimpostfxPlay('MP_BountyLagrasSwamp')
          Wait(Config.SniffOil.EffectTime)
          AnimpostfxStopAll()
        end
      elseif dist > 200 then
        Wait(2000)
      end
    end
  end
end)
