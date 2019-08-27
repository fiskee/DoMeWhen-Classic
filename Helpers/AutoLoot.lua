local DMW = DMW
DMW.Helpers.AutoLoot = {}

local Looting = false

function DMW.Helpers.AutoLoot.Run()
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
end