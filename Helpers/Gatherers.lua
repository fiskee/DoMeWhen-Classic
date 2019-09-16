local DMW = DMW
DMW.Helpers.Gatherers = {}
local Looting = false
local Skinning = false

function DMW.Helpers.Gatherers.Run()
    if DMW.Player:Standing() and not DMW.Player.Casting and not IsMounted() and not UnitIsDeadOrGhost("player") then
        if DMW.Settings.profile.Helpers.AutoLoot then
            if Looting and (DMW.Time - Looting) > 0.6 and not DMW.Player.Looting then
                Looting = false
            end
            if not Looting and not DMW.Player.Combat then
                for _, Unit in pairs(DMW.Units) do
                    if Unit.Dead and Unit.Distance < 1.5 and UnitCanBeLooted(Unit.Pointer) then
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
                    if Unit.Dead and Unit.Distance < 1.5 and UnitCanBeSkinned(Unit.Pointer) then
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
end
