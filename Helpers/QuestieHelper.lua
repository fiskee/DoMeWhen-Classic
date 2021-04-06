local 
libdraw = LibStub("libdraw-1.0")
local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.QuestieHelper = {}

function DMW.Helpers.DrawLineDMWC(sx, sy, sz, ex, ey, ez)
    local function WorldToScreen(wX, wY, wZ)
        local sX, sY = _G.WorldToScreen(wX, wY, wZ)
	local a = 1;
	local b = 1;
	if wmbapi then
		a = 1365;
		b = 768;
	end
	if sX and sY then
		return sX*a, -(WorldFrame:GetTop() - sY*b)
	elseif sX then
		return sX*a, sY;
	elseif sY then
		return sX, sY*b;
	else
		return sX, sY;
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
    libdraw.Draw2DLine(startx, starty, endx, endy)
end

function DMW.Helpers.QuestieHelper.Run()
    if DMW.Settings.profile.Tracker.QuestieHelper then
        local s = 1
        local tX, tY, tZ
        local r, b, g, a = DMW.Settings.profile.Tracker.QuestieHelperColor[1], DMW.Settings.profile.Tracker.QuestieHelperColor[2], DMW.Settings.profile.Tracker.QuestieHelperColor[3], DMW.Settings.profile.Tracker.QuestieHelperColor[4]
        libdraw.SetColorRaw(r, b, g, a)
        for _, Unit in pairs(DMW.Units) do
            if Unit.Quest and (not Unit.Dead or UnitCanBeLooted(Unit.Pointer)) and not Unit.Target and not UnitIsTapDenied(Unit.Pointer) then
                if tonumber(DMW.Settings.profile.Tracker.QuestieHelperAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    FlashClientIcon()
                    if GetCVarBool("Sound_EnableSFX") then
                        PlaySound(DMW.Settings.profile.Tracker.QuestieHelperAlert)
                    else
                        PlaySound(DMW.Settings.profile.Tracker.QuestieHelperAlert, "MASTER")
                    end
                    AlertTimer = DMW.Time
                end
                Unit:UpdatePosition()
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                libdraw.SetWidth(4)
                libdraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                libdraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                libdraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                if DMW.Settings.profile.Tracker.QuestieHelperLine > 0 then
                    local w = DMW.Settings.profile.Tracker.QuestieHelperLine
                    libdraw.SetWidth(w)
                    DMW.Helpers.DrawLineDMWC(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
                end
            end
        end
        for _, Object in pairs(DMW.GameObjects) do
            if Object.Quest then
                if tonumber(DMW.Settings.profile.Tracker.QuestieHelperAlert) > 0 and (AlertTimer + 5) < DMW.Time and not IsForeground() then
                    FlashClientIcon()
                    if GetCVarBool("Sound_EnableSFX") then
                        PlaySound(DMW.Settings.profile.Tracker.QuestieHelperAlert)
                    else
                        PlaySound(DMW.Settings.profile.Tracker.QuestieHelperAlert, "MASTER")
                    end
                    AlertTimer = DMW.Time
                end
                tX, tY, tZ = Object.PosX, Object.PosY, Object.PosZ
                libdraw.SetWidth(4)
                libdraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                libdraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                libdraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
                if DMW.Settings.profile.Tracker.QuestieHelperLine > 0 then
                    local w = DMW.Settings.profile.Tracker.QuestieHelperLine
                    libdraw.SetWidth(w)
                    DMW.Helpers.DrawLineDMWC(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
                end
            end
        end
    end
end
