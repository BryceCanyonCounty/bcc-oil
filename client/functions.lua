--Pulling Essentials
VORPcore = exports.vorp_core:GetCore()
BccUtils = exports['bcc-utils'].initiate()
MiniGame = exports['bcc-minigames'].initiate()
FeatherMenu =  exports['feather-menu'].initiate()

BCCOilMainMenu = FeatherMenu:RegisterMenu('bcc-oil:mainmenu', {
    top = '40%',  -- Adjust top position as needed
    left = '20%',  -- Position on the right side with 20px from the edge
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {},
    contentslot = {
        style = {
            ['height'] = '350px',
            ['min-height'] = '250px'
        }
    },
    draggable = true
}, {
    opened = function()
        DisplayRadar(false)
    end,
    closed = function()
        DisplayRadar(true)
    end,
  })

function distcheck(x, y, z, dist, entity) --Function used to handle distance checking
    while true do
        if Playerdead or WagonDestroyed or Roboilwagondeadcheck or Roboilcodeadcheck then break end
        Wait(100)
        local ec = GetEntityCoords(entity)
        local dist2 = GetDistanceBetweenCoords(ec.x, ec.y, ec.z, x, y, z, true)
        if dist2 < dist then
            break
        elseif dist2 > dist + 100 then
            Wait(1000)
        end
    end
end

function PlayerCarryBox(props) --Function for making player carry a box
    SetEntityAsMissionEntity(props, true, true)
    RequestAnimDict("mech_carry_box")
    while not HasAnimDictLoaded("mech_carry_box") do
        Wait(100)
    end
    local pl = PlayerPedId()
    Citizen.InvokeNative(0xEA47FE3719165B94, pl ,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0)
    Citizen.InvokeNative(0x6B9BBD38AB0796DF, props, pl ,GetEntityBoneIndexByName(pl,"SKEL_R_Finger12"), 0.20, 0.028, -0.15, 100.0, 205.0, 20.0, true, true, false, true, 1, true)
end

function LoadModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end
    RequestModel(model, false)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

function MutltiPedSpawnDeadCheck(pedstable, type, weapon)
    local modelName = 'a_m_m_huntertravelers_cool_01'
    local model = joaat(modelName)
    LoadModel(model, modelName)

    local roboilwagonpeds = {}
    for _, coords in ipairs(pedstable) do
        local ped = CreatePed(model, coords.x, coords.y, coords.z, 0, true, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
        TaskCombatPed(ped, PlayerPedId(), 0, 16)
        Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, ped)
        GiveWeaponToPed_2(ped, weapon, 100, true, false, 0, false, 0.5, 1.0, 752097756, false, 0.0,
        false)
        table.insert(roboilwagonpeds, ped)
    end

    -- Monitor the death status of NPCs
    local aliveCount = #roboilwagonpeds
    while aliveCount > 0 and not Roboilwagondeadcheck and not Roboilcodeadcheck do
        Wait(60)
        for i = #roboilwagonpeds, 1, -1 do
            if IsEntityDead(roboilwagonpeds[i]) then
                table.remove(roboilwagonpeds, i)
                aliveCount = aliveCount - 1
            end
        end
    end

    if Roboilwagondeadcheck or Roboilcodeadcheck then
        -- Mission failed
        for _, ped in ipairs(roboilwagonpeds) do
            DeletePed(ped)
        end
        DeleteEntity(Robableoilwagon)
        VORPcore.NotifyRightTip(_U('Missionfailed'), 4000)
    elseif aliveCount == 0 then
        if type == 'wagonrob' then
            roboilwagonreturnwagon()
        elseif type == 'oilcorob' then
            finishOilCompanyRobbery()
        end
    end
end


function BlipWaypoin(x, y, z, blipname) --func to make blip and waypoint and return the blip
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, -1282792512, x, y, z, 5)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipname)
    BccUtils.Misc.SetGps(x, y, z)
    return blip
end

function CoordRandom(coordstable) --funct to pick random coords from table
    local mathr1 = math.random(1, #coordstable)
    return coordstable[mathr1]
end
