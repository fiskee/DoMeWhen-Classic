local LibDraw = LibStub("LibDraw-1.0")
local DMW = DMW
DMW.Helpers.Quest = {}

function DMW.Helpers.Quest.Run()
    LibDraw.clearCanvas()
    if DMW.Settings.profile.Helpers.QuestieHelper then
        local s = 1
        local tX, tY, tZ
        for _, Unit in pairs(DMW.Units) do
            if Unit.Quest and (not Unit.Dead or UnitCanBeLooted(Unit.Pointer)) and not Unit.Target and not UnitIsTapDenied(Unit.Pointer) then
                tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
                LibDraw.SetColor(0, 255, 0)
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
            end
        end
        for _, Object in pairs(DMW.GameObjects) do
            if Object.Quest then
                tX, tY, tZ = Object.PosX, Object.PosY, Object.PosZ
                LibDraw.SetColor(0, 255, 0)
                LibDraw.SetWidth(4)
                LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
                LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
                LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
            end
        end
    end
end
