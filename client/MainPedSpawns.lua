------ Handles spawning of main peds ------
local npcs = {}
local blips = {}
Citizen.CreateThread(function()
  local model = joaat(Config.ManagerPedModel)
  if Config.ManagerBlip then
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z) -- This create a blip with a defualt blip hash we given
    SetBlipSprite(blip, Config.ManagerBlipHash, 1) -- This sets the blip hash to the given in config.
    SetBlipScale(blip, 0.8) --sets the blip scale
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.ManagerBlipColor)) --sets the blip color
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Language.ManagerBlip) -- Sets the blip Name
    table.insert(blips, blip) --Store the blip in the blips table
  end
  modelload(model)
  local createdped = CreatePed(model, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z - 1, OilWagonTable.ManagerSpawn.h, false, true, true, true) --creates ped the minus one makes it so its standing on the ground not floating first boolean is for network. Disabled so only 1 ped shows per player
  mainpedspawnStatusSetup(createdped) --triggers the event for setting the main peds status as invincible etc
  while true do --creates a loop that will run the whole time your in game
    Citizen.Wait(5) --makes it wait a slight amount (avoids crashing is needed)
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
      end
    end
  end
end)

--Criminal Ped Spawn Setup
Citizen.CreateThread(function()
  local model = joaat(Config.CriminalPedModel)
  if Config.CriminalPedBlip then --if config setting true then if false it wont run
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z)
    SetBlipSprite(blip, Config.CriminalBlipHash, 1)
    SetBlipScale(blip, 0.8)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.CriminalBlipColor))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Language.CriminalPedBlip)
    table.insert(blips, blip)
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
        TriggerServerEvent('bcc:oil:DBCheck')
      end
    end
  end
end)

-- Function to delete NPCs
function DeleteNPCs()
  for k, v in pairs(npcs) do
      DeletePed(v)
  end
end

-- Function to delete blips
function DeleteBlips()
  for k, v in pairs(blips) do
      RemoveBlip(v)
  end
end

-- Call the DeleteNPCs function when the resource stops
AddEventHandler("onResourceStop", function(resource)
  if resource == GetCurrentResourceName() then
      DeleteNPCs()
      DeleteBlips()
  end
end)