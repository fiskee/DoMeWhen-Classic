local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")

function DMW.Helpers.Trackers.Run()
    local tX, tY, tZ
    if (DMW.Settings.profile.Tracker.TrackUnits and DMW.Settings.profile.Tracker.TrackUnits ~= "") or DMW.Settings.profile.Tracker.TrackNPC then
        local s = 1
        for _, Unit in pairs(DMW.Units) do
            -- if Unit.Player then return end
            if DMW.Settings.profile.Tracker.TrackNPC and not Unit.Player and Unit.Friend then
                local r, b, g, a = DMW.Settings.profile.Tracker.TrackNPCColor[1], DMW.Settings.profile.Tracker.TrackNPCColor[2], DMW.Settings.profile.Tracker.TrackNPCColor[3], DMW.Settings.profile.Tracker.TrackNPCColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                for k, v in pairs(DMW.Enums.NpcFlags) do
                    if Unit:HasNPCFlag(v) then
                        LibDraw.Text(k, "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
                        break
                    end
                end
            end
            if (DMW.Settings.profile.Tracker.TrackUnits ~= nil and DMW.Settings.profile.Tracker.TrackUnits ~= "") and not Unit.Player and Unit.Trackable and not Unit.Dead and not Unit.Target then
                local r, b, g, a = DMW.Settings.profile.Tracker.TrackUnitsColor[1], DMW.Settings.profile.Tracker.TrackUnitsColor[2], DMW.Settings.profile.Tracker.TrackUnitsColor[3], DMW.Settings.profile.Tracker.TrackUnitsColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                if DMW.Settings.profile.Tracker.TrackUnitsAlert > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    FlashClientIcon()
                    if GetCVarBool("Sound_EnableSFX") then
                        PlaySound(DMW.Settings.profile.Tracker.TrackUnitsAlert)
                    else
                        PlaySound(DMW.Settings.profile.Tracker.TrackUnitsAlert, "MASTER")
                    end
                    AlertTimer = DMW.Time
                end
                Unit:UpdatePosition()
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                if DMW.Settings.profile.Tracker.TrackUnitsLine > 0 then
                    local w = DMW.Settings.profile.Tracker.TrackUnitsLine
                    LibDraw.SetWidth(w)
                    DMW.Helpers.DrawLineDMWC(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
                end
            end
            -- if Unit.NPC ~= false then
            --     LibDraw.Text(Unit.NPC, "GameFontNormal", self.PosX, self.PosY, self.PosZ + 2)
            -- end
        end
    end
    for _, Object in pairs(DMW.GameObjects) do
        if Object.Herb then
            local r, b, g, a = DMW.Settings.profile.Tracker.HerbsColor[1], DMW.Settings.profile.Tracker.HerbsColor[2], DMW.Settings.profile.Tracker.HerbsColor[3], DMW.Settings.profile.Tracker.HerbsColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            if DMW.Settings.profile.Tracker.HerbsAlert > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(DMW.Settings.profile.Tracker.HerbsAlert)
                else
                    PlaySound(DMW.Settings.profile.Tracker.HerbsAlert, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Tracker.HerbsLine > 0 then
                local w = DMW.Settings.profile.Tracker.HerbsLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        elseif Object.Ore then
            local r, b, g, a = DMW.Settings.profile.Tracker.OreColor[1], DMW.Settings.profile.Tracker.OreColor[2], DMW.Settings.profile.Tracker.OreColor[3], DMW.Settings.profile.Tracker.OreColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            ----------------------------------------------------------------------------
            if DMW.Settings.profile.Tracker.OreAlert > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(DMW.Settings.profile.Tracker.OreAlert)
                else
                    PlaySound(DMW.Settings.profile.Tracker.OreAlert, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Tracker.OreLine > 0 then
                local w = DMW.Settings.profile.Tracker.OreLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        elseif Object.Trackable then
            local r, b, g, a = DMW.Settings.profile.Tracker.TrackObjectsColor[1], DMW.Settings.profile.Tracker.TrackObjectsColor[2], DMW.Settings.profile.Tracker.TrackObjectsColor[3], DMW.Settings.profile.Tracker.TrackObjectsColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            ----------------------------------------------------------------------------
            if DMW.Settings.profile.Tracker.TrackObjectsAlert > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                local sound = DMW.Settings.profile.Tracker.TrackObjectsAlert
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(sound)
                else
                    PlaySound(sound, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Tracker.TrackObjectsLine > 0 then
                local w = DMW.Settings.profile.Tracker.TrackObjectsLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        elseif DMW.Settings.profile.Tracker.TrackObjectsMailbox and strmatch(string.lower(Object.Name), "mailbox") then
            local r, b, g, a = DMW.Settings.profile.Tracker.TrackObjectsColor[1], DMW.Settings.profile.Tracker.TrackObjectsColor[2], DMW.Settings.profile.Tracker.TrackObjectsColor[3], DMW.Settings.profile.Tracker.TrackObjectsColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            local w = DMW.Settings.profile.Tracker.TrackObjectsLine
            LibDraw.SetWidth(w)
            DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
        end
    end
    if DMW.Settings.profile.Tracker.TrackPlayersNamePlates or (DMW.Settings.profile.Tracker.TrackPlayers ~= "") or DMW.Settings.profile.Tracker.TrackPlayersAny or DMW.Settings.profile.Tracker.TrackPlayersEnemy then
        local Color
        local s = 1

        for _, Unit in pairs(DMW.Units) do
            if ((DMW.Settings.profile.Tracker.TrackPlayers ~= nil and DMW.Settings.profile.Tracker.TrackPlayers ~= "") or DMW.Settings.profile.Tracker.TrackPlayersAny or DMW.Settings.profile.Tracker.TrackPlayersEnemy)
             and Unit.Player and not Unit.Dead and Unit.Trackable and not UnitIsUnit("target", Unit.Pointer) then
                local r, b, g, a = DMW.Settings.profile.Tracker.TrackPlayersColor[1], DMW.Settings.profile.Tracker.TrackPlayersColor[2], DMW.Settings.profile.Tracker.TrackPlayersColor[3], DMW.Settings.profile.Tracker.TrackPlayersColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                if DMW.Settings.profile.Tracker.TrackPlayersAlert > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    local sound = DMW.Settings.profile.Tracker.TrackPlayersAlert
                    FlashClientIcon()
                    if GetCVarBool("Sound_EnableSFX") then
                        PlaySound(sound)
                    else
                        PlaySound(sound, "MASTER")
                    end
                    AlertTimer = DMW.Time
                end
                Unit:UpdatePosition()
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                if DMW.Settings.profile.Tracker.TrackPlayersLine > 0 then
                    local w = DMW.Settings.profile.Tracker.TrackPlayersLine
                    LibDraw.SetWidth(w)
                    DMW.Helpers.DrawLineDMWC(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
                end
            end
            if DMW.Settings.profile.Tracker.TrackPlayersNamePlates and Unit.Player and not Unit.Dead and not UnitIsFriend("player", Unit.Pointer) and not C_NamePlate.GetNamePlateForUnit(Unit.Pointer) then
                Unit:UpdatePosition()
                Color = DMW.Enums.ClassColor[Unit.Class]
                LibDraw.SetColor(Color.r, Color.g, Color.b)
                LibDraw.Text(Unit.Name .. " (" .. Unit.Level .. ") - HP: " .. Unit.HP .. " - " .. math.floor(Unit.Distance) .. " Yards", "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
            end
        end
    end
end
