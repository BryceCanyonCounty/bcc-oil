------ Handles spawning the wagons -----
Createdwagon = 0
WagonModel = nil
local sw = OilWagonTable.WagonSpawnCoords
RegisterNetEvent('bcc:oil:PlayerWagonSpawn', function(wagonModel)
  Inmission = true
  WagonModel = wagonModel
  local modelName = wagonModel
  local model = joaat(modelName)
  LoadModel(model, modelName)
  VORPcore.NotifyRightTip(_U('WagonSpawned'), 4000)
  Createdwagon = CreateVehicle(model, sw.x, sw.y, sw.z, sw.w, true, true)
  TriggerEvent('bcc:oil:PlayerWagonDistFromSpawnCheck')
  local wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, Createdwagon)
  if wagonModel == 'oilwagon02x' then
    SetBlipSprite(wagonBlip, Config.OilWagonBilpHash, true)
    Citizen.InvokeNative(0x662D364ABF16DE2F, wagonBlip, joaat(Config.OilWagonBlipColor))
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, _U('OilWagonBlipName'))
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck')
    beginningstage()
  elseif wagonModel == 'armysupplywagon' then
    SetBlipSprite(wagonBlip, Config.SupplyWagonBilpHash, true)
    Citizen.InvokeNative(0x662D364ABF16DE2F, wagonBlip, joaat(Config.SupplyWagonBlipColor))
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, _U('SupplyWagonBlipName'))
    TriggerEvent('bcc-oil:WagonDeliveriesDeadCheck')
    supplymissionbeginstage()
  end
end)

---------------Creates a client event to check distance the wagon is from spawn coords/if it is disable wagons from spawning/if it isnt allow wagons to spawn again ----------------------
AddEventHandler('bcc:oil:PlayerWagonDistFromSpawnCheck', function()
  local isnear = false
  while true do
    Wait(1000)
    if not WagonDestroyed and not Playerdead then
      local wagoncoords = GetEntityCoords(Createdwagon)
      if DoesEntityExist(Createdwagon) then
        if GetDistanceBetweenCoords(sw.x, sw.y, sw.z, wagoncoords.x, wagoncoords.y, wagoncoords.z, false) > 20 then
          if not isnear then
            isnear = true
            TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
          end
        else
          isnear = false
          TriggerServerEvent('bcc-oil:WagonInSpawnHandler', true)
        end
      end
    else
      DeleteEntity(Createdwagon)
      Wait(1000)
      WagonDestroyed = false
      Playerdead = false
      TriggerServerEvent('bcc-oil:WagonInSpawnHandler', false)
      Wait(Config.OilWagonFillTime + 5000)
      Progressbardeadcheck = false break
    end
  end
end)

--------Creates a client event that will be used throughout the whole of both wagon missions too see if you or the wagon is dead and if so change variable to true to stop the missions----
Playerdead, WagonDestroyed, Progressbardeadcheck = false, false, false
AddEventHandler('bcc-oil:WagonDeliveriesDeadCheck', function()
  while true do
    Wait(100)
    if GetEntityHealth(Createdwagon) == 0 or not DoesEntityExist(Createdwagon) or IsEntityDead(PlayerPedId()) then
      Inmission = false
      Progressbardeadcheck = true
      WagonDestroyed = true
      Playerdead = true break
    end
  end
end)
