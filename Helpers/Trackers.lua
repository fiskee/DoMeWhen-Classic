local DMW = DMW
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")
local AlertTimer = GetTime()

local function DrawLine(sx, sy, sz, ex, ey, ez)
    local function WorldToScreen(wX, wY, wZ)
        local sX, sY = _G.WorldToScreen(wX, wY, wZ)
        if sX and sY then
            return sX, -(WorldFrame:GetTop() - sY)
        else
            return sX, sY
        end
    end
    local startx, starty = WorldToScreen(sx, sy, sz)
    local endx, endy = WorldToScreen(ex, ey, ez)
    if (endx == nil or endy == nil) and (startx and starty) then
        local i = 1
        while (endx == nil or endy == nil) and i < 50 do
            endx, endy = WorldToScreen(GetPositionBetweenPositions(ex, ey, ez, sx, sy, sz, i))
            i = i + 1
        end
    end
    if (startx == nil or starty == nil) and (endx and endy) then
        local i = 1
        while (startx == nil or starty == nil) and i < 50 do
            startx, starty = WorldToScreen(GetPositionBetweenPositions(sx, sy, sz, ex, ey, ez, i))
            i = i + 1
        end
    end
    LibDraw.Draw2DLine(startx, starty, endx, endy)
end

function DMW.Helpers.Trackers.Run()
    if (DMW.Settings.profile.Helpers.TrackUnits and DMW.Settings.profile.Helpers.TrackUnits ~= "") or DMW.Settings.profile.Helpers.TrackNPC then
        LibDraw.SetColor(255, 165, 0)
        local s = 1
        local tX, tY, tZ
        for _, Unit in pairs(DMW.Units) do
            if DMW.Settings.profile.Helpers.TrackNPC and not Unit.Player and Unit.Friend then
                for k,v in pairs(DMW.Enums.NpcFlags) do
                    if Unit:HasNPCFlag(v) then
                        LibDraw.Text(k, "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
                        break
                    end
                end
            end
            if (DMW.Settings.profile.Helpers.TrackUnits and DMW.Settings.profile.Helpers.TrackUnits ~= "") and Unit.Trackable and not Unit.Dead and not Unit.Target then
                if DMW.Settings.profile.Helpers.TrackAlert and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    FlashClientIcon()
                    PlaySound(416)
                    AlertTimer = DMW.Time
                end
                Unit:UpdatePosition()
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
            end
            -- if Unit.NPC ~= false then
            --     LibDraw.Text(Unit.NPC, "GameFontNormal", self.PosX, self.PosY, self.PosZ + 2)
            -- end
        end
    end
    LibDraw.SetColor(255, 0, 0)
    for _, Object in pairs(DMW.GameObjects) do
        if Object.Herb or Object.Ore or Object.Trackable then
            if DMW.Settings.profile.Helpers.TrackAlert and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                PlaySound(416)
                AlertTimer = DMW.Time
            end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Helpers.LineToNodes then
                DrawLine(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        end
    end
    if DMW.Settings.profile.Helpers.TrackPlayers then
        local Color
        for _, Unit in pairs(DMW.Units) do
            if Unit.Player and not Unit.Dead and not UnitIsFriend("player", Unit.Pointer) and not C_NamePlate.GetNamePlateForUnit(Unit.Pointer) and not UnitIsUnit("target", Unit.Pointer) then
                Unit:UpdatePosition()
                Color = DMW.Enums.ClassColor[Unit.Class]
                LibDraw.SetColor(Color.r, Color.g, Color.b)
                LibDraw.Text(Unit.Name .. " (" .. Unit.Level .. ") - HP: " .. Unit.HP .. " - " .. math.floor(Unit.Distance) .. " Yards", "GameFontNormalSmall", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
            end
        end
    end
end
