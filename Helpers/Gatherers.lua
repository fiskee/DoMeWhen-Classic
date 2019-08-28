local DMW = DMW
DMW.Helpers.Gatherers = {}
local LibDraw = LibStub("LibDraw-1.0")
local Looting = false

function DMW.Helpers.Gatherers.Run()
    if DMW.Settings.profile.Helpers.AutoLoot then
        if Looting and (DMW.Time - Looting) > 1.3 then
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
    LibDraw.SetColor(255, 0, 0)
    for _, Object in pairs(DMW.GameObjects) do
        if Object.Herb or Object.Ore then
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        end
    end
end
