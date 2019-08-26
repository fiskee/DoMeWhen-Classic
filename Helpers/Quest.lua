local LibDraw = LibStub("LibDraw-1.0")
local DMW = DMW
local Unit = DMW.Classes.Unit

local function Line(sx, sy, sz, ex, ey, ez)
    local function WorldToScreen (wX, wY, wZ)
        local sX, sY = _G.WorldToScreen(wX, wY, wZ);
        if sX and sY then
            return sX, -(WorldFrame:GetTop() - sY);
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
    LibDraw.Draw2DLine(startx, starty, endx, endy)
end

function Unit:Quest()
    if QuestieTooltips and QuestieTooltips.tooltipLookup["u_" .. self.Name] then
        for _, Tooltip in pairs(QuestieTooltips.tooltipLookup["u_" .. self.Name]) do
            Tooltip.Objective:Update()
            if not Tooltip.Objective.Completed then
                return true
            end
        end
    end
    return false
end

function DMW.Helpers.Quest()
    LibDraw.clearCanvas()
    if DMW.Settings.profile.Helpers.QuestieHelper then
        local s = 1
        local tX, tY, tZ
        for _, Unit in pairs(DMW.Units) do
            if Unit:Quest() then
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetColor(0,255,0)
                LibDraw.SetWidth(4)
                Line(tX, tY, tZ+s*1.3, tX, tY, tZ)
                Line(tX-s, tY, tZ, tX+s, tY, tZ)
                Line(tX, tY-s, tZ, tX, tY+s, tZ)
            end
        end
    end
end
