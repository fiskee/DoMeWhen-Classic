local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:UnitDetailedThreatSituation(OtherUnit)
	OtherUnit = OtherUnit or DMW.Player
	local isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue = UnitDetailedThreatSituation(OtherUnit.Pointer, self.Pointer)
	if isTanking ~= nil then
		return isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue
	else
		return nil, 0, nil, nil, 0
	end
end

function Unit:UnitThreatSituation(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
	return select(2, self:UnitDetailedThreatSituation(OtherUnit))
end

function Unit:IsTanking()
	for _, Unit in pairs(DMW.Enemies) do
		if (Unit:UnitThreatSituation(self) and Unit:UnitThreatSituation(self) > 1) or (Unit.Target and UnitIsUnit(self.Pointer, Unit.Target)) then
			return true
		end
	end
	return false
end
