------ Handles spawning of main peds ------
local npcs, blips = {}, {}
CreateThread(function()
  local model = joaat(Config.ManagerPedModel)
  if Config.ManagerBlip then
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z)
    SetBlipSprite(blip, Config.ManagerBlipHash, 1)
    SetBlipScale(blip, 0.8)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.ManagerBlipColor))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Language.ManagerBlip)
    table.insert(blips, blip)
  end
  modelload(model)
  local createdped = CreatePed(model, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z - 1, OilWagonTable.ManagerSpawn.h, false, true, true, true)
  Citizen.InvokeNative(0x283978A15512B2FE, createdped, true)
  BccUtils.Ped.SetStatic(createdped)
  while true do
    Wait(5)
    local playercoord = GetEntityCoords(PlayerPedId())
    local dist = GetDistanceBetweenCoords(playercoord.x, playercoord.y, playercoord.z, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, true)
    if dist < 5 then
      BccUtils.Misc.DrawText3D(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, Config.Language.ManagerDrawText)
      if IsControlJustReleased(0, 0x760A9C6F) then
        SetNuiFocus(true, true)
        SendNUIMessage({ --this sends an nui message to the app.js file
          type = 'open', --it passes the variable type
          config = Config --passes the config table to the js
        })
        TriggerServerEvent('bcc:oil:DBCheck') --triggers the server event to make sure you exist in the database
      end
    elseif dist > 200 then
      Wait(2000)
    end
  end
end)

--Criminal Ped Spawn Setup
CreateThread(function()
  local model = joaat(Config.CriminalPedModel)
  if Config.CriminalPedBlip then
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z)
    SetBlipSprite(blip, Config.CriminalBlipHash, 1)
    SetBlipScale(blip, 0.8)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.CriminalBlipColor))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Language.CriminalPedBlip)
    table.insert(blips, blip)
  end
  modelload(model)
  local createdped = CreatePed(model, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z - 1, Config.CriminalPedSpawn.h, false, true, true, true)
  Citizen.InvokeNative(0x283978A15512B2FE, createdped, true)
  BccUtils.Ped.SetStatic(createdped)
  while true do
    Wait(5)
    local pl = GetEntityCoords(PlayerPedId())
    local dist = GetDistanceBetweenCoords(pl.x, pl.y, pl.z, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z, true)
    if dist < 5 then
      BccUtils.Misc.DrawText3D(Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z, Config.Language.CriminalDrawText) --draws text on the manager
      if IsControlJustReleased(0, 0x760A9C6F) then --if g is pressed then
        SetNuiFocus(true, true) --sets nui focus gives you mouse control
        SendNUIMessage({ --sends a nui message triggering the js script
          type = 'open2', --sends the type var as open2
          config = Config --sends the config table too the js file
        })
        TriggerServerEvent('bcc:oil:DBCheck')
      end
    elseif dist > 200 then
      Wait(2000)
    end
  end
end)

------ Cleanup ------
AddEventHandler("onResourceStop", function(resource)
  if resource == GetCurrentResourceName() then
    for k, v in pairs(npcs) do
      DeletePed(v)
    end
    for k, v in pairs(blips) do
      RemoveBlip(v)
    end
  end
end)