local DMW = DMW
local Player, Swing



DMW.Helpers.Swing = {}
DMW.Tables.Swing = {}
Swing = DMW.Tables.Swing

Swing.Player = {}
Swing.Units = {}

Player = Swing.Player

Player.SwingMH = 0.00001
Player.OldMHSpeed = 2
Player.MHSpeed = 2
Player.idMH = GetInventoryItemID("player", 16)
Player.MHSpeedChanged = false

Player.SwingOH = 0.00001
Player.OldOHSpeed = 2
Player.OHSpeed = 2
Player.idOH = GetInventoryItemID("player", 17)
Player.HasOH = false
Player.OHSpeedChanged = false

Swing.Reset = {}

Swing.Reset['WARRIOR'] = {
    ["Cleave"] = true,
    ["Heroic Strike"] = true,
    ["Slam"] = true
}

Swing.Reset['DRUID'] = {
    ["Maul"] = true
}
--===============================================--=================================================--=================================================--=================================================--=================================================
DMW.Helpers.Swing.AddUnit = function (unit)
    if DMW.Tables.Swing.Units[unit] == nil then
        DMW.Tables.Swing.Units[unit] = {}

        DMW.Tables.Swing.Units[unit].SwingMH = 0.00001
        DMW.Tables.Swing.Units[unit].OldMHSpeed = 2
        DMW.Tables.Swing.Units[unit].MHSpeed = 2
        DMW.Tables.Swing.Units[unit].MHSpeedChanged = false

    end
end

DMW.Helpers.Swing.SwingMHReset = function(unit)
    if unit == "player" or unit == DMW.Player.Pointer then
        -- print("player")
        Player.SwingMH = Player.MHSpeed
    else
        -- print(unit)
        if Swing.Units[unit] ~= nil then
            Swing.Units[unit].SwingMH = Swing.Units[unit].MHSpeed
        end
    end
end

DMW.Helpers.Swing.SwingOHReset = function(unit)
    if unit == "player" or unit == DMW.Player.Pointer then
        if Player.HasOH then
            Player.SwingOH = Player.OHSpeed
        end
    else
        if Swing.Units[unit] ~= nil then
            Swing.Units[unit].SwingOH = Swing.Units[unit].OHSpeed
        end
    end
end

-- sitenrage = true

DMW.Helpers.Swing.SwingMHUpdate = function(elapsed, unit)
    if unit == "player" or unit == DMW.Player.Pointer then
        if Player.SwingMH > 0 then
            Player.SwingMH = Player.SwingMH - elapsed
            if Player.SwingMH < 0 then
                Player.SwingMH = 0
            end
            DMW.Player.SwingMH = Player.SwingMH
        end
    else
        if Swing.Units[unit].SwingMH > 0 then
            Swing.Units[unit].SwingMH = Swing.Units[unit].SwingMH - elapsed
            if Swing.Units[unit].SwingMH < 0 then
                Swing.Units[unit].SwingMH = 0
            end
            DMW.Units[unit].SwingMH = Swing.Units[unit].SwingMH

            -- if DMW.Units[unit].SwingMH <= 0.15 and DMW.Units[unit].SwingMH > 0.01 and DMW.Units[unit].Target == DMW.Player.Pointer and not DMW.Player.Moving and DMW.Player.HP > 20 and sitenrage then
            --     RunMacroText("/sit")
            --     -- print(DMW.Time - batchTime)
            --     sitenrage = false
            -- end

        end
    end
end

DMW.Helpers.Swing.SwingOHUpdate = function(elapsed, unit)
    if unit == "player" or unit == DMW.Player.Pointer then
        if Player.HasOH then
            if Player.SwingOH > 0 then
                Player.SwingOH = Player.SwingOH - elapsed
                if Player.SwingOH < 0 then
                    Player.SwingOH = 0
                end
                DMW.Player.SwingOH = Player.SwingOH
            end
        else
            DMW.Player.SwingOH = false
        end
    else
        if Swing.Units[unit].HasOH then
            if Swing.Units[unit].SwingOH > 0 then
                Swing.Units[unit].SwingOH = Swing.Units[unit].SwingOH - elapsed
                if Swing.Units[unit].SwingOH < 0 then
                    Swing.Units[unit].SwingOH = 0
                end
            end
        end
    end
end

DMW.Helpers.Swing.SpeedMHUpdate = function(unit)
    if unit == "player" or unit == DMW.Player.Pointer then
        Player.OldMHSpeed = Player.MHSpeed
        Player.MHSpeed = UnitAttackSpeed("player")
        if Player.MHSpeed ~= Player.OldMHSpeed then
            Player.MHSpeedChanged = true
        else
            Player.MHSpeedChanged = false
        end
    else
        Swing.Units[unit].OldMHSpeed = Swing.Units[unit].MHSpeed
        Swing.Units[unit].MHSpeed = UnitAttackSpeed(unit)
        if Swing.Units[unit].MHSpeed ~= Swing.Units[unit].OldMHSpeed then
            Swing.Units[unit].MHSpeedChanged = true
        else
            Swing.Units[unit].MHSpeedChanged = false
        end
    end
end

DMW.Helpers.Swing.SpeedOHUpdate = function(unit)
    if unit == "player" or unit == DMW.Player.Pointer then 
        Player.OldOHSpeed = Player.OHSpeed
        Player.OHSpeed = select(2, UnitAttackSpeed("player"))
        -- Check to see if we have an off-hand
        if (not Player.OHSpeed) or (Player.OHSpeed == 0) then
            Player.HasOH = false
        else
            Player.HasOH = true
        end
        if Player.OHSpeed ~= Player.OldOHSpeed then
            Player.OHSpeedChanged = true
        else
            Player.OHSpeedChanged = false
        end
    else
        Swing.Units[unit].OldOHSpeed = Swing.Units[unit].OHSpeed
        Swing.Units[unit].OHSpeed = select(2, UnitAttackSpeed(unit))
        -- Check to see if we have an off-hand
        if (not Swing.Units[unit].OHSpeed) or (Swing.Units[unit].OHSpeed == 0) then
            Swing.Units[unit].HasOH = false
        else
            Swing.Units[unit].HasOH = true
        end
        if Swing.Units[unit].OHSpeed ~= Swing.Units[unit].OldOHSpeed then
            Swing.Units[unit].OHSpeedChanged = true
        else
            Swing.Units[unit].OHSpeedChanged = false
        end
    end
end

DMW.Helpers.Swing.Run = function(elapsed)
        DMW.Helpers.Swing.SpeedMHUpdate("player")
        DMW.Helpers.Swing.SpeedOHUpdate("player")

        if Player.MHSpeed == 0 then
            Player.MHSpeed = 2
        end
        if Player.OHSpeed == 0 then
            Player.OHSpeed = 2
        end

        if Player.MHSpeedChanged or Player.OHSpeedChanged then
            local multiMH = Player.MHSpeed / Player.OldMHSpeed
            Player.SwingMH = Player.SwingMH * multiMH
            if Player.HasOH and Player.OldOHSpeed then
                local multiOH = (Player.OHSpeed / Player.OldOHSpeed)
                Player.SwingOH = Player.SwingOH * multiOH
            end
        end
        DMW.Helpers.Swing.SwingMHUpdate(elapsed,"player")
        DMW.Helpers.Swing.SwingOHUpdate(elapsed, "player")

        for unit, _ in pairs(Swing.Units) do
            -- add oh swings ?? --
            -- print(unit)
            DMW.Helpers.Swing.SpeedMHUpdate(unit)
            if Swing.Units[unit].MHSpeed == 0 then
                Swing.Units[unit].MHSpeed = 2
            end
            if Swing.Units[unit].MHSpeedChanged then
                local multiMH = Swing.Units[unit].MHSpeed / Swing.Units[unit].OldMHSpeed
                Swing.Units[unit].SwingMH = Swing.Units[unit].SwingMH * multiMH
            end
            DMW.Helpers.Swing.SwingMHUpdate(elapsed, unit)
        end
end

DMW.Helpers.Swing.OnInventoryChange = function()
    local idMHnew = GetInventoryItemID("player", 16)
    local idOHnew = GetInventoryItemID("player", 17)
    if Player.idMH ~= idMHnew then
        DMW.Helpers.Swing.SpeedMHUpdate("player")
        DMW.Helpers.Swing.SwingMHReset("player")
    end
    Player.idMH = idMHnew
    if Player.idOH ~= idOHnew then
        DMW.Helpers.Swing.SpeedOHUpdate("player")
        DMW.Helpers.Swing.SwingOHReset("player")
    end
    Player.idOH = idOHnew
end

DMW.Helpers.Swing.MissHandler = function(unit, missType, offhand, destination)
    if missType == "PARRY" then
        local parryHaste
        if unit == DMW.Player.Pointer then
            ------------ check this ??????? -------------------------
            if DMW.Tables.Swing.Units[destination] ~= nil then
                parryHaste = 0.2 * DMW.Tables.Swing.Units[destination].MHSpeed
                if DMW.Tables.Swing.Units[destination].SwingMH > parryHaste then
                    DMW.Tables.Swing.Units[destination].SwingMH = parryHaste
                end
            end
            if not offhand then
                DMW.Helpers.Swing.SwingMHReset("player")
            else
                DMW.Helpers.Swing.SwingOHReset("player")
            end
        else
            if DMW.Tables.Swing.Units[unit] ~= nil then
                if destination == DMW.Player.Pointer then
                    parryHaste = Player.MHSpeed * 0.2
                    if Player.SwingMH > parryHaste then
                        Player.SwingMH = parryHaste
                    end
                end
                if not offhand then
                    DMW.Helpers.Swing.SwingMHReset(unit)
                -- else
                --     DMW.Helpers.Swing.SwingOHReset(unit)
                end
            end
        end
    else
        if unit == DMW.Player.Pointer then
            if not offhand then
                DMW.Helpers.Swing.SwingMHReset("player")
            else
                DMW.Helpers.Swing.SwingOHReset("player")
            end 
        else
            if DMW.Tables.Swing.Units[unit] then
                if not offhand then
                    DMW.Helpers.Swing.SwingMHReset(unit)
                -- else
                --     DMW.Helpers.Swing.SwingOHReset(unit)
                end 
            end
        end
    end
end