local DMW = DMW
DMW.Helpers.Gatherers = {}
local LibDraw = LibStub("LibDraw-1.0")
local Looting = false
local Skinning = false

local function Line(sx, sy, sz, ex, ey, ez)
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

function DMW.Helpers.Gatherers.Run()
    if DMW.Player:Standing() and not DMW.Player.Casting then
        if DMW.Settings.profile.Helpers.AutoLoot then
            if Looting and (DMW.Time - Looting) > 1.3 and not DMW.Player.Looting then
                Looting = false
            end
            if not Looting and not DMW.Player.Combat then
                for _, Unit in pairs(DMW.Units) do
                    if Unit.Dead and Unit.Distance < 5 and UnitCanBeLooted(Unit.Pointer) then
                        InteractUnit(Unit.Pointer)
                        Looting = DMW.Time
                    end
                end
            end
        end
        if DMW.Settings.profile.Helpers.AutoSkinning then
            if Skinning and (DMW.Time - Skinning) > 2.3 then
                Skinning = false
            end
            if not Skinning and not DMW.Player.Combat and not DMW.Player.Moving and not DMW.Player.Casting then
                for _, Unit in pairs(DMW.Units) do
                    if Unit.Dead and Unit.Distance < 5 and UnitCanBeSkinned(Unit.Pointer) then
                        InteractUnit(Unit.Pointer)
                        Skinning = DMW.Time
                    end
                end
            end
        end
        if DMW.Settings.profile.Helpers.AutoGather then
            if Looting and (DMW.Time - Looting) > 0.6 then
                Looting = false
            end
            if not Looting and not DMW.Player.Combat and not DMW.Player.Moving then
                for _, Object in pairs(DMW.GameObjects) do
                    if (Object.Herb or Object.Ore or Object.Trackable) and Object.Distance < 5 then
                        ObjectInteract(Object.Pointer)
                        Looting = DMW.Time
                    end
                end
            end
        end
    end
    LibDraw.SetColor(0, 0, 255)
    if DMW.Settings.profile.Helpers.TrackUnits then
        local TrackUnits = {}
        local s = 1
        local tX, tY, tZ
        for k in string.gmatch(DMW.Settings.profile.Helpers.TrackUnits, "([^,]+)") do
            table.insert(TrackUnits, string.trim(k))
        end
        for _, Unit in pairs(DMW.Units) do
            for i = 1, #TrackUnits do
                if strmatch(Unit.Name, TrackUnits[i]) and not Unit.Dead and not Unit.Target then
                    tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                    LibDraw.SetWidth(4)
                    LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                    LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                    LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                end
            end
        end
    end
    LibDraw.SetColor(255, 0, 0)
    for _, Object in pairs(DMW.GameObjects) do
        if Object.Herb or Object.Ore or Object.Trackable then
            if DMW.Settings.profile.Helpers.TrackSound and not IsForeground() then PlaySound(416) end
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
            if DMW.Settings.profile.Helpers.LineToNodes then
                Line(Object.PosX, Object.PosY, Object.PosZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
            end
        end
    end
end
