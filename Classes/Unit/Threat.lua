local DMW = DMW
local Unit = DMW.Classes.Unit
local ThreatLib = LibStub:GetLibrary("ThreatClassic-1.0")
ThreatLib:RequestActiveOnSolo(true)

function Unit:UnitDetailedThreatSituation(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    local isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue = nil, 0, nil, nil, 0

	local unitGUID, targetGUID = OtherUnit.GUID, self.GUID
	local threatValue = ThreatLib:GetThreat(unitGUID, targetGUID) or 0
	if threatValue == 0 then
		return isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue
	end

	local targetTargetVal = 0
	if self.Target then
		local targetTargetGUID = UnitGUID(self.Target)
		targetTargetVal = ThreatLib:GetThreat(unitGUID, targetTargetGUID) or 0
	end

	local isPlayer
	if OtherUnit == DMW.Player then isPlayer = true end
	local class = select(2, UnitClass(OtherUnit.Pointer))

	local aggroMod = 1.3
	if isPlayer and ThreatLib:UnitInMeleeRange(targetGUID) or (not isPlayer and (class == "ROGUE" or class == "WARRIOR")) or (strsplit("-", unitGUID) == "Pet" and class ~= "MAGE") then
		aggroMod = 1.1
	end

	local maxVal, maxGUID = ThreatLib:GetMaxThreatOnTarget(targetGUID)

	local aggroVal = 0
	if targetTargetVal >= maxVal / aggroMod then
		aggroVal = targetTargetVal
	else
		aggroVal = maxVal
	end

	local hasTarget = self.Target or false

	if threatValue >= aggroVal then
		if hasTarget and UnitIsUnit(OtherUnit.Pointer, self.Target) then
			isTanking = 1
			if unitGUID == maxGUID then
				threatStatus = 3
			else
				threatStatus = 2
			end
		else
			threatStatus = 1
		end
	end

	rawThreatPercent = threatValue / aggroVal * 100

	if isTanking or (not hasTarget and threatStatus ~= 0 ) then
		threatPercent = 100
	else
		threatPercent = rawThreatPercent / aggroMod
	end

	threatValue = floor(threatValue)

	return isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue
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