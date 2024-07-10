------ Handles spawning of main peds ------
local npcs, blips = {}, {}

local createBlip = function(x, y, z, color, blipHash, blipName)
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z)
    SetBlipSprite(blip, blipHash, 1)
    SetBlipScale(blip, 0.8)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(color))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName)
    table.insert(blips, blip)
end

CreateThread(function()
    local model = joaat(Config.ManagerPedModel)
    if Config.ManagerBlip then
        createBlip(OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z,
            Config.ManagerBlipColor, Config.ManagerBlipHash, _U('ManagerBlip'))
    end
    modelload(model)
    local createdped = CreatePed(model, OilWagonTable.ManagerSpawn.x, OilWagonTable.ManagerSpawn.y,
        OilWagonTable.ManagerSpawn.z - 1, OilWagonTable.ManagerSpawn.h, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, createdped, true)
    BccUtils.Ped.SetStatic(createdped)
    local BCCOilMenuPrompt = BccUtils.Prompts:SetupPromptGroup()
    local bccoilprompt = BCCOilMenuPrompt:RegisterPrompt(_U('OilManagerOpenMenu'), 0x760A9C6F, 1, 1, true, 'hold', {
        timedeventhash = 'MEDIUM_TIMED_EVENT'
    })
    while true do
        Wait(5)
        local playercoord = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(playercoord.x, playercoord.y, playercoord.z, OilWagonTable.ManagerSpawn.x,
            OilWagonTable.ManagerSpawn.y, OilWagonTable.ManagerSpawn.z, true)
        if dist < 5 then
            BCCOilMenuPrompt:ShowGroup(_U('OilManagerMainMenuName'))
            if bccoilprompt:HasCompleted() then
                OpenOilMenu()
                TriggerServerEvent('bcc:oil:DBCheck')
            end
        elseif dist > 200 then
            Wait(2000)
        end
    end
end)

-- Criminal Ped Spawn Setup
CreateThread(function()
    local model = joaat(Config.CriminalPedModel)
    if Config.CriminalPedBlip then
        createBlip(Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y, Config.CriminalPedSpawn.z,
            Config.CriminalBlipColor, Config.CriminalBlipHash, _U('CriminalPedBlip'))
    end
    modelload(model)
    local createdped = CreatePed(model, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y,
        Config.CriminalPedSpawn.z - 1, Config.CriminalPedSpawn.h, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, createdped, true)
    BccUtils.Ped.SetStatic(createdped)
    local RobOilMenuPrompt = BccUtils.Prompts:SetupPromptGroup()
    local robprompt = RobOilMenuPrompt:RegisterPrompt(_U('OilManagerOpenMenu'), 0x760A9C6F, 1, 1, true, 'hold', {
        timedeventhash = 'MEDIUM_TIMED_EVENT'
    })
    while true do
        Wait(5)
        local pl = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(pl.x, pl.y, pl.z, Config.CriminalPedSpawn.x, Config.CriminalPedSpawn.y,
            Config.CriminalPedSpawn.z, true)
        if dist < 5 then
            RobOilMenuPrompt:ShowGroup(_U('CriminalPedBlip'))
            if robprompt:HasCompleted() then
                OpenRobberyMenu()
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
