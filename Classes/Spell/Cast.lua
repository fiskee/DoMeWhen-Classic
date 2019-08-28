local DMW = DMW
local Spell = DMW.Classes.Spell

function Spell:FacingCast(Unit, Rank)
	if DMW.Settings.profile.Enemy.AutoFace and self:CastTime(Rank) == 0 and not Unit.Facing and not UnitIsUnit("Player", Unit) then
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
    if self:IsReady(Rank) and (Unit.Distance <= self.MaxRange or IsSpellInRange(self.SpellName, Unit.Pointer) == 1) then
        if self.CastType == "Ground" then
            if self:CastGround(Unit.PosX, Unit.PosY, Unit.PosZ) then
                self.LastBotTarget = Unit.Pointer
            else
                return false
            end
        else
            self:FacingCast(Unit, Rank)
            self.LastBotTarget = Unit.Pointer
        end
        return true
    end
    return false
end

function Spell:CastPool(Unit, Extra, Rank)
	Extra = Extra or 0
	if (self.Cost + Extra) > DMW.Player.Power then
		return true
	end
	return self:Cast(Unit, Rank)
end

function Spell:CastGround(X, Y, Z, Rank)
    if self:IsReady() then
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