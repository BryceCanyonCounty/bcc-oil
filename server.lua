--[[##############################################################################################################################]]
-----------------------------------------Pulling Essentials-------------------------------------------------------------------------
--[[###############################################################################################################################]]
local VORPcore = {} --Pulls vorp core
TriggerEvent("getCore", function(core)
  VORPcore = core
end)
local VORPInv = {}
VORPInv = exports.vorp_inventory:vorp_inventoryApi()

--[[#########################This will handle giving you your reward + bonus amount and adding to your level when completing an oil mission###################################]]
RegisterServerEvent('bcc:oil:PayoutOilMission') --registers server event
AddEventHandler('bcc:oil:PayoutOilMission', function(Wagon) --makes the event have code to run and recieves variable from client
  local _source = source --gets players source
  local Character = VORPcore.getUser(_source).getUsedCharacter --checks the char used
  local charidentifier = Character.charIdentifier --This is the static id of your character
  local identifier = Character.identifier --steam id
  local levelincrease = Config.LevelIncreasePerDelivery --sets the variable to equal config option
  local param = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['levelincrease'] = levelincrease } --sets params for export below
  exports.oxmysql:execute('UPDATE oil SET `manager_trust`=manager_trust+@levelincrease WHERE charidentifier=@charidentifier AND identifier=@identifier', param) --increase your level in database table manager_trust by what is set in the config
  exports.oxmysql:execute("SELECT manager_trust FROM oil WHERE charidentifier=@charidentifier AND identifier=@identifier", param, function(result)
    local trust = result[1].manager_trust --This is the trust variable from the database
    for k, v in pairs(Config.OilCompanyLevels) do --for loop in the table in config
      if trust >= v.level and trust < v.nextlevel then --detects your level if its greater than or equal to the level and less than the next then
        if Wagon == 'oilwagon02x' then --if the variable then
          Character.addCurrency(0, Config.BasicOilDeliveryPay + v.payoutbonus) break -- Add money basepay + paybonus and break loop so it only adds the money once
        elseif Wagon == 'armysupplywagon' then --if the variable then
          Character.addCurrency(0, Config.SupplyDeliveryBasePay + v.payoutbonus) break --base pay plus paybonus break loop
        end
      elseif trust < v.level then --This will only ever trigger if your lower than the very first level and if you are it will only give you base pay
        if Wagon == 'oilwagon02x' then --if variable then
          Character.addCurrency(0, Config.BasicOilDeliveryPay) break --gives you the set base pay then breaks loop
        elseif Wagon == 'armysupplywagon' then
          Character.addCurrency(0, Config.SupplyDeliveryBasePay) break
        end
      end
    end
  end)
end)

--{{#######################This will handle payment upon completing a criminal misison##################################}}
RegisterServerEvent('bcc-oil:RobberyPayout') --creates a server event with that name
AddEventHandler('bcc-oil:RobberyPayout', function() --makes the event have code too run
  local _source = source --gets players source
  local Character = VORPcore.getUser(_source).getUsedCharacter --checks the char used
  local charidentifier = Character.charIdentifier --This is the static id of your character
  local identifier = Character.identifier --steam id
  local levelincrease = Config.LevelIncreasePerDelivery --sets the variable to equal config option
  local levdecrease = Config.OilCompanyLevelDecrease --sets var to the config option
  local param = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['levelincrease'] = levelincrease, ['managelevdecrease'] = levdecrease } --sets the parameters to export to db
  exports.oxmysql:execute("SELECT manager_trust FROM oil WHERE charidentifier=@charidentifier AND identifier=@identifier", param, function(result) --selects the trust value in db
    if result[1].manager_trust > 0 then --if trust is greater than 0 then
      exports.oxmysql:execute('UPDATE oil SET `manager_trust`=manager_trust-@managelevdecrease WHERE charidentifier=@charidentifier AND identifier=@identifier', param) --removes manager trust levels
    end
  end)
  exports.oxmysql:execute('UPDATE oil SET `enemy_trust`=enemy_trust+@levelincrease WHERE charidentifier=@charidentifier AND identifier=@identifier', param) --increase your level in database table manager_trust by what is set in the config
  exports.oxmysql:execute("SELECT enemy_trust FROM oil WHERE charidentifier=@charidentifier AND identifier=@identifier", param, function(result) --selects enemy trust from db and creates a funciton to run
    local trust = result[1].enemy_trust --This is the trust variable from the database
    for k, v in pairs(Config.CriminalLevels) do --for loop in the table in config
      if trust >= v.level and trust < v.nextlevel then --detects your level if its greater than or equal to the level and less than the next then
        Character.addCurrency(0, Config.StealOilWagonBasePay + v.payoutbonus) break --pays base pay + bonus pay breaks loop
      elseif trust < v.level then --else the trust is less than the first level then
        Character.addCurrency(0, Config.StealOilWagonBasePay) break --just pays base pay and breaks loop
      end
    end
  end)
end)

RegisterServerEvent('bcc-oil:OilCoRobberyPayout') --registers  aserver event
AddEventHandler('bcc-oil:OilCoRobberyPayout', function(fillcoords2) --makes the event have code to run and catches variable from client
  local Character = VORPcore.getUser(source).getUsedCharacter --checks the char used
  if fillcoords2.rewards.itemspayout then --if option is true then
    Character.addCurrency(0, fillcoords2.rewards.cashpayout) --adds money
    for k, v in pairs(fillcoords2.rewards.items) do --creates a for loop set in the rewards.items table(this will run this code once per table)
      VORPInv.addItem(source, v.item, v.count) --adds the items
    end
  else --else the option is not true then
    Character.addCurrency(0, fillcoords2.rewards.cashpayout) --just adds cash
  end
end)

--[[#############################################################################################################################]]
-----------------------Handles Database Creation/entries/wagonspawn---------------------------------------------------------------
--[[##############################################################################################################################]]
---------Creates DataBase -----------
Citizen.CreateThread(function()
  --Using oxmysql to create the table if its not already made every time script is launched
  --will create a table in database and add those columns to it
  exports.oxmysql:execute([[CREATE TABLE if NOT EXISTS `oil` (
    `identifier` varchar(50) NOT NULL,
    `charidentifier` int(11) NOT NULL,
    `manager_trust` int(100) NOT NULL DEFAULT 0,
    `enemy_trust`  int(100) NOT NULL DEFAULT 0,
    `oil_wagon` varchar(50) NOT NULL DEFAULT 'none',
    `delivery_wagon` varchar(50) NOT NULL DEFAULT 'none',
    UNIQUE KEY `identifier` (`identifier`))
  ]])
end)

---------Will Create the player into the database if player does not already exist in the database ----------------
RegisterServerEvent('bcc:oil:DBCheck')
AddEventHandler('bcc:oil:DBCheck', function()
  local Character = VORPcore.getUser(source).getUsedCharacter --checks the char used
  local charidentifier = Character.charIdentifier --This is the static id of your character
  local identifier = Character.identifier --steam id
  local param = { ['charidentifier'] = charidentifier, ['identifier'] = identifier }
  --------The if you exist in db code was pulled from vorp_banking and modified ----------------
  exports.oxmysql:execute("SELECT identifier, charidentifier FROM oil WHERE identifier = @Playeridentifier AND charidentifier = @CharIdentifier", { ["@Playeridentifier"] = identifier, ["CharIdentifier"] = charidentifier }, function(result) --Checks if you exist in the database
    if result[1] then --This will run if your char id or player id is in the db already
      --Player already exists do nothing
    else --this will run if you do not exist in the db(adds your char id and player id to the database)
      exports.oxmysql:execute("INSERT INTO oil ( `charidentifier`,`identifier` ) VALUES ( @charidentifier,@identifier )", param) --If player is not in db this will create him in the db
    end
  end)
end)

------------------------------------- Handles the buying, selling, and spawning of wagons ---------------------------------------------
local wagoninspawn = false
RegisterServerEvent('bcc:oil:WagonManagement')
AddEventHandler('bcc:oil:WagonManagement', function(type, action)
  local _source = source --sets _source to source. Unsure why but the notifies would not work without doing this
  local Character = VORPcore.getUser(_source).getUsedCharacter --checks the char used
  local charidentifier = Character.charIdentifier --This is the static id of your character
  local identifier = Character.identifier --steam id
  --------- If wagon type set in menusetup is oilwagon then-----------
  if type == 'oilwagon' then
    local param = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['oilwagon'] = 'oilwagon02x' } --sets params for the sql below
    exports.oxmysql:execute("SELECT oil_wagon FROM oil WHERE charidentifier=@charidentifier AND identifier=@identifier", param, function(result) --gets oil_wagon from the players database
      ---------If action from menusetup is buy then
      if action == 'buy' then
        if result[1].oil_wagon == 'none' then --since the default value is none if you dont own a wagon then
          if Character.money >= Config.OilWagon.price then --checks if you have more money than needed if so then
            Character.removeCurrency(0, Config.OilWagon.price) --removes the money
            exports.oxmysql:execute("UPDATE oil SET `oil_wagon`=@oilwagon WHERE charidentifier=@charidentifier AND identifier=@identifier", param) --adds the oil wagon to the players database row
            VORPcore.NotifyRightTip(_source, Config.Language.OilWagonBought, 4000) --prints on screen
          else
            VORPcore.NotifyRightTip(_source, Config.Language.NotEnoughCash, 4000) --else you do not have enough money prints on screen
          end
        else --if its anything besides none (you own a wagon) then
          VORPcore.NotifyRightTip(_source, Config.Language.OilWagonAlreadyBought, 4000) --only prints on screen
        end
        ---------Elseif action from menusetup is sell then ---------------------
      elseif action == 'sell' then
        if result[1].oil_wagon == 'none' then --will return none if you do not own a wagon. then
          VORPcore.NotifyRightTip(_source, Config.Language.NoWagontoSell, 4000) --prints on screen
        elseif result[1].oil_wagon == 'oilwagon02x' then --if you do own the oil wagon then
          local param2 = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['oilwagon'] = 'none' } --creates the params used by sql below
          exports.oxmysql:execute("UPDATE oil SET `oil_wagon`=@oilwagon WHERE charidentifier=@charidentifier AND identifier=@identifier", param2) --will change the oil_wagon column of the player back to default vale of none
          Character.addCurrency(0, Config.OilWagon.sellprice) --adds the money set in config
          VORPcore.NotifyRightTip(_source, Config.Language.WagonSold, 4000) --prints on screen
        end
        -------------Elseif action from menusetup is spawn then ----------------------
      elseif action == 'spawn' then
        if wagoninspawn == false then --checks if the wagoninspawn variable is false
          if result[1].oil_wagon == 'none' then --will return none if you do not own a wagon. then
            VORPcore.NotifyRightTip(_source, Config.Language.NoWagonOwned, 4000) --prints on screen
          elseif result[1].oil_wagon == 'oilwagon02x' then --if you do own the oil wagon then
            local wagon = 'oilwagon02x'
            wagoninspawn = true --Sets variable to true so that no more wagons can spawn until the bcc:oil:WagonHasLeftSpawn event has ran and reset it
            TriggerClientEvent('bcc:oil:PlayerWagonSpawn', _source, wagon) --Triggers client event to spawn the wagon and passes the wagon hash to it ina variable
          end
        else
          VORPcore.NotifyRightTip(_source, Config.Language.WagonInSpawnLocation, 4000)
        end
      end
    end)
  elseif type == 'supplywagon' then
    local param = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['oilwagon'] = 'armysupplywagon' } --sets params for the sql below
    exports.oxmysql:execute("SELECT delivery_wagon FROM oil WHERE charidentifier=@charidentifier AND identifier=@identifier", param, function(result) --gets oil_wagon from the players database
      ---------If action from menusetup is buy then
      if action == 'buy' then
        if result[1].delivery_wagon == 'none' then --since the default value is none if you dont own a wagon then
          if Character.money >= Config.SupplyWagon.price then --checks if you have more money than needed if so then
            Character.removeCurrency(0, Config.SupplyWagon.price) --removes the money
            exports.oxmysql:execute("UPDATE oil SET `delivery_wagon`=@oilwagon WHERE charidentifier=@charidentifier AND identifier=@identifier", param) --adds the oil wagon to the players database row
            VORPcore.NotifyRightTip(_source, Config.Language.SupplyWagonBought, 4000) --prints on screen
          else
            VORPcore.NotifyRightTip(_source, Config.Language.NotEnoughCash, 4000) --else you do not have enough money prints on screen
          end
        else --if its anything besides none (you own a wagon) then
          VORPcore.NotifyRightTip(_source, Config.Language.SupplyWagonAlreadyBought, 4000) --only prints on screen
        end
        ---------Elseif action from menusetup is sell then ---------------------
      elseif action == 'sell' then
        if result[1].delivery_wagon == 'none' then --will return none if you do not own a wagon. then
          VORPcore.NotifyRightTip(_source, Config.Language.NoWagontoSell, 4000) --prints on screen
        elseif result[1].delivery_wagon == 'armysupplywagon' then --if you do own the oil wagon then
          local param2 = { ['charidentifier'] = charidentifier, ['identifier'] = identifier, ['oilwagon'] = 'none' } --creates the params used by sql below
          exports.oxmysql:execute("UPDATE oil SET `delivery_wagon`=@oilwagon WHERE charidentifier=@charidentifier AND identifier=@identifier", param2) --will change the oil_wagon column of the player back to default vale of none
          Character.addCurrency(0, Config.SupplyWagon.sellprice) --adds the money set in config
          VORPcore.NotifyRightTip(_source, Config.Language.WagonSold, 4000) --prints on screen
        end
        -------------Elseif action from menusetup is spawn then ----------------------
      elseif action == 'spawn' then
        if wagoninspawn == false then --checks if the wagoninspawn variable is false
          if result[1].delivery_wagon == 'none' then --will return none if you do not own a wagon. then
            VORPcore.NotifyRightTip(_source, Config.Language.NoWagonOwned, 4000) --prints on screen
          elseif result[1].delivery_wagon == 'armysupplywagon' then --if you do own the oil wagon then
            local wagon = 'armysupplywagon'
            wagoninspawn = true --Sets variable to true so that no more wagons can spawn until the bcc:oil:WagonHasLeftSpawn event has ran and reset it
            TriggerClientEvent('bcc:oil:PlayerWagonSpawn', _source, wagon) --Triggers client event to spawn the wagon and passes the wagon hash to it ina variable
          end
        else
          VORPcore.NotifyRightTip(_source, Config.Language.WagonInSpawnLocation, 4000)
        end
      end
    end)
  end
end)

--------------Handles making sure the wagon has left the spawn location before allowing a new one to spawn/returend too -------------
--this event is for if wagon leaves spawn then allow more to spawn
RegisterServerEvent('bcc:oil:WagonHasLeftSpawn')
AddEventHandler('bcc:oil:WagonHasLeftSpawn', function()
  wagoninspawn = false --resets the variable so that a player can spawn a wagon again
end)

--this event is for if the wagon returns to spawn make it so no wagons can spawn again
RegisterServerEvent('bcc:oil:WagonHasArrivedInSpawn')
AddEventHandler('bcc:oil:WagonHasArrivedInSpawn', function()
  wagoninspawn = true --resets the variable so that a player can spawn a wagon again
end)

--This handles the version check
local versioner = exports['bcc-versioner'].initiate()
local repo = 'https://github.com/jakeyboi1/bcc-oil'
versioner.checkRelease(GetCurrentResourceName(), repo)