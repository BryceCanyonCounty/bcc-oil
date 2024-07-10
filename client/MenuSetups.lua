Inmission = false
function OpenOilMenu()
    local companyoilMainMenu = BCCOilMainMenu:RegisterPage("Company:Oil:Main:Page")

    companyoilMainMenu:RegisterElement('header', {
        value = _U('OilManagerMainMenuName'),
        slot = 'header',
        style = {}
    })

    companyoilMainMenu:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    companyoilMainMenu:RegisterElement('button', {
        label = _U('NUIOilMenu'),
        style = {},
    }, function()
        OpenOilWagonMenu()
    end)

    companyoilMainMenu:RegisterElement('button', {
        label = _U('Supplymenuname'),
        style = {},
    }, function()
        OpenSupplyMenu()
    end)

    companyoilMainMenu:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    companyoilMainMenu:RegisterElement('button', {
        label = _U('NUIExitMenu'),
        slot = 'footer',
        style = {},
    }, function()
        BCCOilMainMenu:Close()
    end)

    companyoilMainMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCOilMainMenu:Open({
        startupPage = companyoilMainMenu
    })
end

function OpenSupplyMenu()
    local supplyMainMenu = BCCOilMainMenu:RegisterPage("Supply:Main:Page")

    supplyMainMenu:RegisterElement('header', {
        value = _U('OilManagerMainMenuName'),
        slot = 'header',
        style = {}
    })

    supplyMainMenu:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    supplyMainMenu:RegisterElement('button', {
        label = _U('NUIBuySupplyWagon') .. Config.SupplyWagon.price,
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'supplywagon', 'buy')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    supplyMainMenu:RegisterElement('button', {
        label = _U('NUISellSupplyWagon') .. Config.SupplyWagon.sellprice,
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'supplywagon', 'sell')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    supplyMainMenu:RegisterElement('button', {
        label = _U('NUIDeliverMission'),
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'supplywagon', 'spawn')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    supplyMainMenu:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    supplyMainMenu:RegisterElement('button', {
        label = _U('OilGoBackButton'),
        slot = 'footer',
        style = {},
    }, function()
        OpenOilMenu()
    end)

    supplyMainMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCOilMainMenu:Open({
        startupPage = supplyMainMenu
    })
end

function OpenOilWagonMenu()
    local oilMainMenu = BCCOilMainMenu:RegisterPage("Oil:Main:Page")

    oilMainMenu:RegisterElement('header', {
        value = _U('OilManagerMainMenuName'),
        slot = 'header',
        style = {}
    })

    oilMainMenu:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    oilMainMenu:RegisterElement('button', {
        label = _U('NUIBuyOilWagon') .. Config.OilWagon.price,
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'oilwagon', 'buy')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    oilMainMenu:RegisterElement('button', {
        label = _U('NUISellOilWagon') .. Config.OilWagon.sellprice,
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'oilwagon', 'sell')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    oilMainMenu:RegisterElement('button', {
        label = _U('NUIDeliverMission'),
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc:oil:WagonManagement', 'oilwagon', 'spawn')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    oilMainMenu:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    oilMainMenu:RegisterElement('button', {
        label = _U('OilGoBackButton'),
        slot = 'footer',
        style = {},
    }, function()
        OpenOilMenu()
    end)

    oilMainMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCOilMainMenu:Open({
        startupPage = oilMainMenu
    })
end

function OpenRobberyMenu()
    local robberyMainMenu = BCCOilMainMenu:RegisterPage("Robbery:Main:Page")

    robberyMainMenu:RegisterElement('header', {
        value = "Robbery",
        slot = 'header',
        style = {}
    })

    robberyMainMenu:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    robberyMainMenu:RegisterElement('button', {
        label = _U('NUIRobOilWagon'),
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc-oil:CrimCooldowns', 'wagonrob')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    robberyMainMenu:RegisterElement('button', {
        label = _U('NUIRobOilCompany'),
        style = {},
    }, function()
        if not Inmission then
            TriggerServerEvent('bcc-oil:CrimCooldowns', 'corob')
            BCCOilMainMenu:Close()
        else
            VORPcore.NotifyRightTip(_U('AlreadyInMission'), 4000)
        end
    end)

    robberyMainMenu:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    robberyMainMenu:RegisterElement('button', {
        label = _U('NUIExitMenu'),
        slot = 'footer',
        style = {},
    }, function()
        BCCOilMainMenu:Close()
    end)

    robberyMainMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCOilMainMenu:Open({
        startupPage = robberyMainMenu
    })
end
