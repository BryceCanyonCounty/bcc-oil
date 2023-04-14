--[[####################################################################################################################################]]
----------------------Handles the spawning of manager ped, setting draw3d text up, and opening menu------------------------------------------------------
--[[####################################################################################################################################]]

--Manager Ped Spawn Setup 
Citizen.CreateThread(function()
  local model = GetHashKey(Config.ManagerPedModel) --sets the npc model
  if Config.ManagerBlip == true then --if blip in config = true then if false this will not run, and will not make a blip
    local blip = VORPutils.Blips:SetBlip(Config.Language.ManagerBlip, 'blip_mp_torch', 0.8, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z) --Creates a blip on the manager location set in config. Using vorp utils
  end
  modelload(model)
  local createdped = CreatePed(model, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z - 1, OilWagonTable.ManagerSpawn.h, false, true, true, true) --creates ped the minus one makes it so its standing on the ground not floating first boolean is for network. Disabled so only 1 ped shows per player
  mainpedspawnStatusSetup(createdped) --triggers the event for setting the main peds status as invincible etc
  while true do --creates a loop that will run the whole time your in game
    Citizen.Wait(5) --makes it wait a slight amount (avoids crashing is needed)
    --This will handle drawing the text on the ped, and opening the menu
    local playercoord = GetEntityCoords(PlayerPedId()) --gets the players ped coordinates
    if GetDistanceBetweenCoords(playercoord.x, playercoord.y, playercoord.z, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, true) < 5 then --gets the distance between coords end boolean is for using x distance
      DrawText3D(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, Config.Language.ManagerDrawText) --draws text on the manager
      if IsControlJustReleased(0, 0x760A9C6F) then
        SetNuiFocus(true, true)
        SendNUIMessage({ --this sends an nui message to the app.js file
          type = 'open', --it passes the variable type
          config = Config --passes the config table to the js
        })
        TriggerServerEvent('bcc:oil:DBCheck') --triggers the server event to make sure you exist in the database
        --WarMenu.OpenMenu('bcc:oil:ManagerMainMenu') --opens the main menu    
      end
    end
  end
end)

--Criminal Ped Spawn Setup
Citizen.CreateThread(function()
  local model = GetHashKey(Config.CriminalPedModel) --gets the models hash key
  if Config.CriminalPedBlip then --if config setting true then if false it wont run
    local blip = VORPutils.Blips:SetBlip(Config.Language.CriminalPedBlip, 'blip_mp_torch', 0.8, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z) --Creates a blip on the manager location set in config. Using vorp utils
  end
  modelload(model) --triggers the function to load the model
  local createdped = CreatePed(model, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z - 1, Config.CriminalPedSpawn.h, false, true, true, true) --creates the ped at the location
  mainpedspawnStatusSetup(createdped) --triggers the function for setting the main ped spawns status as invincible etc
  while true do --creates a while true do loop which wont end until broken
    Citizen.Wait(5) --waits 5ms prevent crashing
    local pl = GetEntityCoords(PlayerPedId()) --sets the var to the players coords
    if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z, true) < 5 then --if dist is less than 5 between player and set location then
      DrawText3D(Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z, Config.Language.CriminalDrawText) --draws text on the manager
      if IsControlJustReleased(0, 0x760A9C6F) then --if g is pressed then
        SetNuiFocus(true, true) --sets nui focus gives you mouse control
        SendNUIMessage({ --sends a nui message triggering the js script
          type = 'open2', --sends the type var as open2
          config = Config --sends the config table too the js file
        })
      end
    end
  end
end)