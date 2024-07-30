CreateThread(function()
    -- Create oil table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `oil` (
            `identifier` varchar(50) NOT NULL,
            `charidentifier` int(11) NOT NULL,
            `manager_trust` int(100) NOT NULL DEFAULT 0,
            `enemy_trust` int(100) NOT NULL DEFAULT 0,
            `oil_wagon` varchar(50) NOT NULL DEFAULT 'none',
            `delivery_wagon` varchar(50) NOT NULL DEFAULT 'none',
            UNIQUE KEY `charidentifier` (`charidentifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    print("Database table for \x1b[35m\x1b[1m*bcc-oil*\x1b[0m created or updated \x1b[32msuccessfully\x1b[0m.")
end)
