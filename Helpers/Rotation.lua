local DMW = DMW
DMW.Helpers.Rotation = {}
local Rotation = DMW.Helpers.Rotation

function Rotation.Active(CastingCheck)
    CastingCheck = CastingCheck or true
    if DMW.Settings.profile.HUD.Rotation == 1 and not UnitIsDeadOrGhost("player") and (not CastingCheck or not DMW.Player.Casting) and not (IsMounted() or IsFlying()) and not DMW.Player.NoControl and DMW.Player:Standing() then
        return true
    end
    return false
end

function Rotation.GetSpellByID(SpellID)
    local SpellName = GetSpellInfo(SpellID)
    for _, Spell in pairs(DMW.Player.Spells) do
        if Spell.SpellName == SpellName then
            return Spell
        end
    end
end

function Rotation.RawDistance(X1, Y1, Z1, X2, Y2, Z2)
    return sqrt(((X1 - X2) ^ 2) + ((Y1 - Y2) ^ 2) + ((Z1 - Z2) ^ 2))
end

function Rotation.Setting(Setting)
    return DMW.Settings.profile.Rotation[Setting]
end
