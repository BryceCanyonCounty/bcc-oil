local T = Translation.Langs[Config.Lang]

--[[######################Nui callbacks####################################]]
--this callback is for when the menu closes giving player control of mouse in game back
Inmission = false
function OilBusinessMenu()
    BCCOilMenu:Close()
    local oilBusinessPage = BCCOilMenu:RegisterPage('bcc-oil:OilBusinessPage')
    oilBusinessPage:RegisterElement('header', {
        value = T.ManagerBlip,
        slot = 'header',
        style = {}
    })

    oilBusinessPage:RegisterElement('button', {
        label = T.NUIBuyOilWagon .. Config.OilWagon.price,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'oilwagon', 'buy'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    oilBusinessPage:RegisterElement('button', {
        label = T.NUISellOilWagon .. Config.OilWagon.sellprice,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'oilwagon', 'sell'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    oilBusinessPage:RegisterElement('button', {
        label = T.NUIDeliverMission,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'oilwagon', 'spawn'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    oilBusinessPage:RegisterElement('button', {
        label = T.NUIBuySupplyWagon .. Config.SupplyWagon.price,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'supplywagon', 'buy'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    oilBusinessPage:RegisterElement('button', {
        label = T.NUISellSupplyWagon .. Config.SupplyWagon.sellprice,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'supplywagon', 'sell'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    oilBusinessPage:RegisterElement('button', {
        label = T.SupplyDeliveryMission,
        style = {}
    }, function()
        if not Inmission then
            local type, action = 'supplywagon', 'spawn'
            TriggerServerEvent('bcc:oil:WagonManagement', type, action)
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)

    BCCOilMenu:Open({
        startupPage = oilBusinessPage
    })
end

function CriminalOilMenu()
    BCCOilMenu:Close()
    local criminalOilPage = BCCOilMenu:RegisterPage('bcc-oil:CriminalOilPage')
    criminalOilPage:RegisterElement('header', {
        value = T.CriminalPedBlip,
        slot = 'header',
        style = {}
    })

    criminalOilPage:RegisterElement('button', {
        label = T.NUIRobOilWagon,
        style = {}
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc-oil:CrimCooldowns', 'wagonrob')
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)
    criminalOilPage:RegisterElement('button', {
        label = T.NUIRobOilCompany,
        style = {}
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc-oil:CrimCooldowns', 'corob')
        else
            VORPcore.NotifyRightTip(T.AlreadyInMission, 4000)
        end
    end)

    BCCOilMenu:Open({
        startupPage = criminalOilPage
    })
end