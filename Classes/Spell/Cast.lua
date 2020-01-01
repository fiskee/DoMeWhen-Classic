local DMW = DMW
local Spell = DMW.Classes.Spell
local CastTimer = GetTime()

function Spell:HighestLevel(Unit)
    local HighestRank
    local SpellLevels = DMW.Enums.BuffLevels[self.Key]
    if SpellLevels then
        -- Find highest known rank for level
        for i=1, #SpellLevels, 1 do
            if Unit.Level >= (tonumber(SpellLevels[i]) - 10) and self:Known(i) then
                HighestRank = i
            end
        end
    end
    return HighestRank
end

function Spell:FacingCast(Unit, Rank)
	if DMW.Settings.profile.Enemy.AutoFace and self:CastTime(Rank) == 0 and not Unit.Facing and not UnitIsUnit("Player", Unit.Pointer) then
		local Facing = ObjectFacing("Player")
		local MouselookActive = false
		if IsMouselooking() then
			MouselookActive = true
			MouselookStop()
		end
		FaceDirection(Unit.Pointer, true)
		if not Rank then
            CastSpellByName(self.SpellName, Unit.Pointer)
        else
            CastSpellByID(self.Ranks[Rank], Unit.Pointer)
        end
		FaceDirection(Facing)
		if MouselookActive then
			MouselookStart()
		end
		C_Timer.After(0.1, function()
			FaceDirection(ObjectFacing("player"), true)
        end)
	else
		if not Rank then
            CastSpellByName(self.SpellName, Unit.Pointer)
        else
            CastSpellByID(self.Ranks[Rank], Unit.Pointer)
        end
	end
end

function Spell:Cast(Unit, Rank)
    if not Unit then
        if self.IsHarmful and DMW.Player.Target then
            Unit = DMW.Player.Target
        elseif self.IsHelpful then
            Unit = DMW.Player
        else
            return false
        end
    end
    if not Rank then
        Rank = self:HighestLevel(Unit)
    end
    if self:Known(Rank) and self:Usable(Rank) and ((Unit.Distance <= self.MaxRange and (self.MinRange == 0 or Unit.Distance >= self.MinRange)) or IsSpellInRange(self.SpellName, Unit.Pointer) == 1) then
        if IsAutoRepeatSpell(DMW.Player.Spells.Shoot.SpellName) and self:CD(Rank) < 0.2 then
            MoveForwardStart()
            MoveForwardStop()
            return true
        elseif self:CD(Rank) == 0 and (DMW.Time - CastTimer) > 0.1 then
            CastTimer = DMW.Time
            if self.CastType == "Ground" then
                if self:CastGround(Unit.PosX, Unit.PosY, Unit.PosZ) then
                    self.LastBotTarget = Unit.Pointer
                else
                    return false
                end
            else
                self:HealCommFix(Rank)
                self:FacingCast(Unit, Rank)
                self.LastBotTarget = Unit.Pointer
            end
            return true
        end
    end
    return false
end

function Spell:HealCommFix(rank)
    DMW.Helpers.HealComm.Settings.timeframe = 0
    if DMW.Player.Class == "SHAMAN" then
        if self.SpellName == "Chain Heal" or self.SpellName == "Lesser Healing Wave" or self.SpellName == "Healing Wave" then
            DMW.Helpers.HealComm.Settings.timeframe = self:CastTime(rank) + 0.2
        end
    elseif DMW.Player.Class == "PRIEST" then
        if self.SpellName == "Greater Heal" or self.SpellName == "Flash Heal" then
            DMW.Helpers.HealComm.Settings.timeframe = self:CastTime(rank) + 0.2
        end
    elseif DMW.Player.Class == "DRUID" then
        if self.SpellName == "Healing Touch" or self.SpellName == "Regrowth" then
            DMW.Helpers.HealComm.Settings.timeframe = self:CastTime(rank) + 0.2
        end
    elseif DMW.Player.Class == "PALADIN" then
        if self.SpellName == "Holy Light" or self.SpellName == "Flash of Light" then
            DMW.Helpers.HealComm.Settings.timeframe = self:CastTime(rank) + 0.2
        end
    end
end

function Spell:CastPool(Unit, Extra, Rank)
	Extra = Extra or 0
	if (self:Cost(Rank) + Extra) > DMW.Player.Power then
		return true
	end
	return self:Cast(Unit, Rank)
end

function Spell:CastGround(X, Y, Z, Rank)
    if self:IsReady(Rank) then
        local MouseLooking = false
        local PX, PY, PZ = DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ
        local Distance = sqrt(((X - PX) ^ 2) + ((Y - PY) ^ 2) + ((Z - PZ) ^ 2))
        if Distance > self.MaxRange then
            X,Y,Z = GetPositionBetweenPositions (X, Y, Z, PX, PY, PZ, Distance - self.MaxRange)
		end
		Z = select(3,TraceLine(X, Y, Z+5, X, Y, Z-5, 0x110))
		if Z ~= nil and TraceLine(PX, PY, PZ+2, X, Y, Z+1, 0x100010) == nil and TraceLine(X, Y, Z+4, X, Y, Z, 0x1) == nil then
            if IsMouselooking() then
                MouseLooking = true
                MouselookStop()
            end
			if not Rank then
				CastSpellByName(self.SpellName)
			else
				CastSpellByID(self.Ranks[Rank])
			end
            ClickPosition(X, Y, Z)
            if MouseLooking then
                MouselookStart()
            end
            return true
        end
    end
    return false
end
