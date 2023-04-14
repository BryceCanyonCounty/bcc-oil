--[[######################Nui callbacks####################################]]
--this callback is for when the menu closes giving player control of mouse in game back
Inmission = false
RegisterNuiCallback('closemenu', function()
  SetNuiFocus(false, false)
end)

--This callback is for purchasing an oil wagon
RegisterNuiCallback('BuyOilWagon', function()
  if not Inmission then --variable is false then
    local type = 'oilwagon' --sets variable to oilwagon
    local action = 'buy' --sets variable to buy
    TriggerServerEvent('bcc:oil:WagonManagement', type, action) --triggers server event and passes the variables to it
  else --else do this
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000) --prints on screen
  end
end)

--This callback is for selling an oil wagon
RegisterNuiCallback('SellOilWagon', function()
  if not Inmission then
    local type = 'oilwagon'
    local action = 'sell'
    TriggerServerEvent('bcc:oil:WagonManagement', type, action)
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

--this callback is for starting an oil delivery mission
RegisterNuiCallback('OilDeliveryMission', function()
  if not Inmission then
    local type = 'oilwagon'
    local action = 'spawn'
    TriggerServerEvent('bcc:oil:WagonManagement', type, action)
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

--this callback is for buying a supply wagon
RegisterNuiCallback('BuySupplyWagon', function()
  if not Inmission then
    local type = 'supplywagon'
    local action = 'buy'
    TriggerServerEvent('bcc:oil:WagonManagement', type, action)
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

--this callback is for selling a supply wagon
RegisterNuiCallback('SellSupplyWagon', function()
  if not Inmission then
    local type = 'supplywagon'
    local action = 'sell'
    TriggerServerEvent('bcc:oil:WagonManagement', type, action)
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

--this callback is for starting a supply delivery mission
RegisterNuiCallback('SupplyDelivery', function()
  if not Inmission then
    local type = 'supplywagon'
    local action ='spawn'
    TriggerServerEvent('bcc:oil:WagonManagement', type, action)
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

-----------Criminal Callbacks--------
RegisterNuiCallback('RobOilWagon', function()
  if not Inmission then
    roboilwagon()
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)

RegisterNuiCallback('RobOilCompany', function()
  if not Inmission then
    roboilco()
  else
    VORPcore.NotifyRightTip(Config.Language.AlreadyInMission, 4000)
  end
end)