local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    if OtherUnit == DMW.Player and DMW.Enums.MeleeSpell[DMW.Player.Class] and IsSpellInRange(GetSpellInfo(DMW.Enums.MeleeSpell[DMW.Player.Class]), self.Pointer) == 1 then
        return 0
    end
    local Dist = sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2)) - ((self.CombatReach or 0) + (OtherUnit.CombatReach or 0))
    if Dist < 0 then
        return 0
    end
    return Dist
end

function Unit:AggroDistance()
    local maxRadius = 45 --.0 * sWorld->getRate(RATE_CREATURE_AGGRO));
    local minRadius = 5 --.0 * sWorld->getRate(RATE_CREATURE_AGGRO));
    -- aggroRate = sWorld->getRate(RATE_CREATURE_AGGRO);
    local expansionMaxLevel = 60

    local playerLevel = DMW.Player.Level
    local creatureLevel = self.Level
    local leveldif = creatureLevel - playerLevel

    if UnitReaction(self.Pointer, "player") >= 4 then --neutral mob
        return 0
    end

    -- // The aggro radius for creatures with equal level as the player is 20 yards.
    -- // The combatreach should not get taken into account for the distance so we drop it from the range (see Supremus as expample)
    local baseAggroDistance = 20 - self.CombatReach --GetCombatReach();
    local aggroRadius = baseAggroDistance;

    -- // detect range auras
    -- if creatureLevel <= 55
    -- {
    --     aggroRadius += GetTotalAuraModifier(SPELL_AURA_MOD_DETECT_RANGE);

    --     aggroRadius += player->GetTotalAuraModifier(SPELL_AURA_MOD_DETECTED_RANGE);
    -- }

    -- // The aggro range of creatures with higher levels than the total player level for the expansion should get the maxlevel treatment
    -- // This makes sure that creatures such as bosses wont have a bigger aggro range than the rest of the npcs
    -- // The following code is used for blizzlike behavior such as skipable bosses (e.g. Commander Springvale at level 85)
    if creatureLevel > 60 then
        aggroRadius = aggroRadius + (expansionMaxLevel - playerLevel)
    -- // + - 1 yard for each level difference between player and creature
    else
        aggroRadius = aggroRadius + (creatureLevel - playerLevel)
    end
    -- // Make sure that we wont go over the total range limits
    if aggroRadius > maxRadius then
        aggroRadius = maxRadius
    elseif aggroRadius < minRadius then
        aggroRadius = minRadius
    end
    
    return aggroRadius --* aggroRate);
end

function Unit:RawDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function Unit:RawFacing()
    return select(2, ObjectFacing(self.Pointer))
end

function Unit:GetFacingAngle(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    local X = OtherUnit.PosX - self.PosX
    local Y = OtherUnit.PosY - self.PosY
    local Angle = self:RawFacing()
    if Angle > math.pi then
        Angle = Angle - (2 * math.pi)
    end
    local DX = math.cos(Angle)
    local DY = math.sin(Angle)
    return(math.abs(math.atan2(X * DY - Y * DX,  X * DX + Y * DY ) * (180 / math.pi)))
end


function Unit:InArc(Arc, OtherUnit)
    if self:GetFacingAngle() < Arc then
        return true
    end
    return false
end

function Unit:IsBehind(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return not self:InArc(90, OtherUnit)
end

function Unit:IsInFront(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return self:InArc(90, OtherUnit)
end