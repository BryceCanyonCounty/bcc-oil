--Pulling Essentials
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)

--Function used to handle distance checking
function distcheck(x, y, z, dist, entity) --receives these variables from whereever it is triggered
    while true do --while loop will not stop until broken
        if Playerdead or WagonDestroyed or Roboilwagondeadcheck or Roboilcodeadcheck then break end --if either variable is true then break loop
        Citizen.Wait(100) --waits 100ms preventing crashing
        local ec = GetEntityCoords(entity) --gets the entities coords
        if GetDistanceBetweenCoords(ec.x, ec.y, ec.z, x, y, z, true) < dist then break end --if the dist between the entity and the coords are less than the dist break loop
    end
end

--Function for Draw 3D Text
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.30, 0.30)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 215)
        SetTextCentre(1)
        DisplayText(str,_x,_y)
        local factor = (string.len(text)) / 225
        DrawSprite("feeds", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 35, 35, 35, 190, 0)
    end
end

--Function for making player carry a box
function PlayerCarryBox(props) --catches var from wherever it is called
    SetEntityAsMissionEntity(prop,true,true) --sets entity as mission entity
    RequestAnimDict("mech_carry_box") --loads the anim
    while not HasAnimDictLoaded("mech_carry_box") do --while the anim hasnt loaded do
        Citizen.Wait(100) --wait 0.1 second
    end
    Citizen.InvokeNative(0xEA47FE3719165B94, PlayerPedId() ,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0) --plays animation
    Citizen.InvokeNative(0x6B9BBD38AB0796DF, props, PlayerPedId() ,GetEntityBoneIndexByName(PlayerPedId(),"SKEL_R_Finger12"), 0.20, 0.028, -0.15, 100.0, 205.0, 20.0, true, true, false, true, 1, true) --puts object in your hand
end

--Function to load model
function modelload(model) --recieves the models hash from whereever this function is called
    RequestModel(model) -- requests the model to load into the game
    if not HasModelLoaded(model) then --checks if its loaded
      RequestModel(model) --if it hasnt loaded then request it to load again
    end
    while not HasModelLoaded(model) do
      Wait(100)
    end
end

--function for setting the main 2 peds invincible etc
function mainpedspawnStatusSetup(createdped)
    Citizen.InvokeNative(0x283978A15512B2FE, createdped, true) -- sets ped into random outfit, stops it being invis
    SetEntityAsMissionEntity(createdped, true, true) -- sets ped as mission entity preventing it from despawning
    SetEntityInvincible(createdped, true) --sets ped invincible
    FreezeEntityPosition(createdped, true) --freezes the entity
    SetBlockingOfNonTemporaryEvents(createdped, true) --makes is so npc wont be scared
end

--function for spawning multiple peds and checking if they are dead
function MutltiPedSpawnDeadCheck(pedstable, type) --catches this variable from wherever it is called
    local model = 'a_m_m_huntertravelers_cool_01' --sets variable to the string the peds hash
    modelload(model) --triggers the function to load the model
    local count = {} --this creates a table used to keep count of wagon defenders(and too see if the count alive is less than starting and if so then they are all dead proceed with the mission)
    local roboilwagonpeds = {} --this creates a table used too store the wagon defenders
    for k, v in pairs(pedstable) do --creates a for loop which runs once per table
        roboilwagonpeds[k] = CreatePed(model, v.x, v.y, v.z, true, true, true, true) --creates the peds and stores them in the table as the [k] key
        Citizen.InvokeNative(0x283978A15512B2FE, roboilwagonpeds[k], true) --creates a blip on each of the npcs
        TaskCombatPed(roboilwagonpeds[k], PlayerPedId()) --makes each npc fight the player
        Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, roboilwagonpeds[k]) --sets the blip that tracks the ped
        count[k] = roboilwagonpeds[k] --sets count to equal the amount of ped spawns
    end
    local x = #pedstable --sets the var to equal the number of tables in the table
    while not Roboilwagondeadcheck and not Roboilcodeadcheck do --while the variable is true do (while nothing has died do)
        Citizen.Wait(60) --waits 60ms prevents crashing
        for k, v in pairs(roboilwagonpeds) do --creates  for loop running once per table
            if IsEntityDead(v) then --if peds are dead then
                if count[k] ~= nil then --if variable not nil then
                    x = x - 1 --x = x - 1
                    count[k] = nil --sets count too nil
                    if x == 0 then --if x = 0 then(all peds are dead)
                        if type == 'wagonrob' then --if the type is this then
                            roboilwagonreturnwagon() break --triggers function and breaks loop
                        elseif type == 'oilcorob' then break end --if the type is this then break end
                    end
                end
            end
        end
    end
    if Roboilwagondeadcheck or Roboilcodeadcheck then --if variable true(you or wagon are dead then)
        for k, v in pairs(roboilwagonpeds) do --creates a for loop in the peds table
          DeletePed(v) --deletes all the peds
        end
        DeleteEntity(Robableoilwagon) --deletes the wagon
        VORPcore.NotifyRightTip(Config.Language.Missionfailed, 4000) return --prints on screen and returns ending this function
    end
end
