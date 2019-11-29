local DMW = DMW
DMW.Helpers.HealComm = {}
local HealComm = DMW.Helpers.HealComm
local HealCommLib = LibStub("LibHealComm-4.0", true)

HealComm.Settings = {
    timeframe = 2,
    showHots = false,
}

function HealComm:OnInitialize()
	HealCommLib.RegisterCallback(self, "HealComm_HealStarted", "HealComm_HealUpdated")
    HealCommLib.RegisterCallback(self, "HealComm_HealStopped")
    HealCommLib.RegisterCallback(self, "HealComm_HealDelayed", "HealComm_HealUpdated")
    HealCommLib.RegisterCallback(self, "HealComm_HealUpdated")
    HealCommLib.RegisterCallback(self, "HealComm_ModifierChanged")
    HealCommLib.RegisterCallback(self, "HealComm_GUIDDisappeared")
end

function HealComm:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)
	self:UpdateIncoming(...)
end

function HealComm:HealComm_HealStopped(event, casterGUID, spellID, healType, interrupted, ...)
	self:UpdateIncoming(...)
end

function HealComm:HealComm_ModifierChanged(event, guid)
	self:UpdateIncoming(guid)
end

function HealComm:HealComm_GUIDDisappeared(event, guid)
	self:UpdateIncoming(guid)
end

function HealComm:UpdateIncoming(...)
	local amount, targetGUID, healType
	if self.Settings.showHots then
		healType = HealCommLib.ALL_HEALS
	else
		healType = HealCommLib.CASTED_HEALS
    end
    for i=1, select("#", ...) do
		targetGUID = select(i, ...)
        amount = (HealCommLib:GetHealAmount(targetGUID, healType, DMW.Time + self.Settings.timeframe) or 0) * (HealCommLib:GetHealModifier(targetGUID) or 1)
		-- self.currentHeals[targetGUID] = amount > 0 and amount
		-- print(amount)
        for k,v in pairs(DMW.Friends.Units) do
            if v.GUID == targetGUID then
                v.PredictedHeal = amount
            end
        end
    end
end


