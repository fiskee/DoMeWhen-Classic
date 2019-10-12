local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")

function DMW.Helpers.Trackers.Run()
    local tX, tY, tZ
    if (DMW.Settings.profile.Helpers.TrackUnits and DMW.Settings.profile.Helpers.TrackUnits ~= "") or DMW.Settings.profile.Helpers.TrackNPC then
        local s = 1
        for _, Unit in pairs(DMW.Units) do
            -- if Unit.Player then return end
            if DMW.Settings.profile.Helpers.TrackNPC and not Unit.Player and Unit.Friend then
                local r, b, g, a = DMW.Settings.profile.Helpers.TrackNPCColor[1], DMW.Settings.profile.Helpers.TrackNPCColor[2], DMW.Settings.profile.Helpers.TrackNPCColor[3], DMW.Settings.profile.Helpers.TrackNPCColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                for k, v in pairs(DMW.Enums.NpcFlags) do
                    if Unit:HasNPCFlag(v) then
                        LibDraw.Text(k, "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
                        break
                    end
                end
            end
            if (DMW.Settings.profile.Helpers.TrackUnits ~= nil and DMW.Settings.profile.Helpers.TrackUnits ~= "") and not Unit.Player and Unit.Trackable and not Unit.Dead and not Unit.Target then
                local r, b, g, a = DMW.Settings.profile.Helpers.TrackUnitsColor[1], DMW.Settings.profile.Helpers.TrackUnitsColor[2], DMW.Settings.profile.Helpers.TrackUnitsColor[3], DMW.Settings.profile.Helpers.TrackUnitsColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                if tonumber(DMW.Settings.profile.Helpers.TrackUnitsAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    FlashClientIcon()
                    if GetCVarBool("Sound_EnableSFX") then
                        PlaySound(DMW.Settings.profile.Helpers.TrackUnitsAlert)
                    else
                        PlaySound(DMW.Settings.profile.Helpers.TrackUnitsAlert, "MASTER")
                    end
                    AlertTimer = DMW.Time
                end
                Unit:UpdatePosition()
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                if DMW.Settings.profile.Helpers.TrackUnitsLine > 0 then
                    local w = DMW.Settings.profile.Helpers.TrackUnitsLine
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
            local r, b, g, a = DMW.Settings.profile.Helpers.HerbsColor[1], DMW.Settings.profile.Helpers.HerbsColor[2], DMW.Settings.profile.Helpers.HerbsColor[3], DMW.Settings.profile.Helpers.HerbsColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            if tonumber(DMW.Settings.profile.Helpers.HerbsAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(DMW.Settings.profile.Helpers.HerbsAlert)
                else
                    PlaySound(DMW.Settings.profile.Helpers.HerbsAlert, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Helpers.HerbsLine > 0 then
                local w = DMW.Settings.profile.Helpers.HerbsLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        elseif Object.Ore then
            local r, b, g, a = DMW.Settings.profile.Helpers.OreColor[1], DMW.Settings.profile.Helpers.OreColor[2], DMW.Settings.profile.Helpers.OreColor[3], DMW.Settings.profile.Helpers.OreColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            ----------------------------------------------------------------------------
            if tonumber(DMW.Settings.profile.Helpers.OreAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(DMW.Settings.profile.Helpers.OreAlert)
                else
                    PlaySound(DMW.Settings.profile.Helpers.OreAlert, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Helpers.OreLine > 0 then
                local w = DMW.Settings.profile.Helpers.OreLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        elseif Object.Trackable then
            local r, b, g, a = DMW.Settings.profile.Helpers.TrackObjectsColor[1], DMW.Settings.profile.Helpers.TrackObjectsColor[2], DMW.Settings.profile.Helpers.TrackObjectsColor[3], DMW.Settings.profile.Helpers.TrackObjectsColor[4]
            LibDraw.SetColorRaw(r, b, g, a)
            ----------------------------------------------------------------------------
            if tonumber(DMW.Settings.profile.Helpers.TrackObjectsAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                local sound = tonumber(DMW.Settings.profile.Helpers.TrackObjectsAlert)
                FlashClientIcon()
                if GetCVarBool("Sound_EnableSFX") then
                    PlaySound(sound)
                else
                    PlaySound(sound, "MASTER")
                end
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Helpers.TrackObjectsLine > 0 then
                local w = DMW.Settings.profile.Helpers.TrackObjectsLine
                LibDraw.SetWidth(w)
                DMW.Helpers.DrawLineDMWC(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        end
    end
    if DMW.Settings.profile.Helpers.TrackPlayersNamePlates or (DMW.Settings.profile.Helpers.TrackPlayers ~= "") then
        local Color
        local s = 1

        for _, Unit in pairs(DMW.Units) do
            if (DMW.Settings.profile.Helpers.TrackPlayers ~= nil and DMW.Settings.profile.Helpers.TrackPlayers ~= "") and Unit.Player and Unit.Trackable and not UnitIsUnit("target", Unit.Pointer) and not Unit.Dead then
                local r, b, g, a = DMW.Settings.profile.Helpers.TrackPlayersColor[1], DMW.Settings.profile.Helpers.TrackPlayersColor[2], DMW.Settings.profile.Helpers.TrackPlayersColor[3], DMW.Settings.profile.Helpers.TrackPlayersColor[4]
                LibDraw.SetColorRaw(r, b, g, a)
                if tonumber(DMW.Settings.profile.Helpers.TrackPlayersAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    local sound = tonumber(DMW.Settings.profile.Helpers.TrackPlayersAlert)
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
                if DMW.Settings.profile.Helpers.TrackPlayersLine > 0 then
                    local w = DMW.Settings.profile.Helpers.TrackPlayersLine
                    LibDraw.SetWidth(w)
                    DMW.Helpers.DrawLineDMWC(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
                end
            elseif DMW.Settings.profile.Helpers.TrackPlayersNamePlates and Unit.Player and not Unit.Dead and not UnitIsFriend("player", Unit.Pointer) and not C_NamePlate.GetNamePlateForUnit(Unit.Pointer) and not UnitIsUnit("target", Unit.Pointer) then
                Unit:UpdatePosition()
                Color = DMW.Enums.ClassColor[Unit.Class]
                LibDraw.SetColor(Color.r, Color.g, Color.b)
                LibDraw.Text(Unit.Name .. " (" .. Unit.Level .. ") - HP: " .. Unit.HP .. " - " .. math.floor(Unit.Distance) .. " Yards", "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
            end
        end
    end
end
