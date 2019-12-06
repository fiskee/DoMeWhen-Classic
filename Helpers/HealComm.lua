local DMW = DMW
DMW.Helpers.HealComm = {}
local HealComm = DMW.Helpers.HealComm
local HealCommLib = LibStub("LibHealComm-4.0", true)

HealComm.Settings = {
    timeframe = 0,
    showHots = false,
}


-- HealComm.PartyGUIDs = {}
-- HealComm.PartyGUIDs.Init = false
function HealComm:OnInitialize()
    if DMW.Player.Class == "SHAMAN" or DMW.Player.Class == "PRIEST" or DMW.Player.Class == "DRUID" or DMW.Player.Class == "PALADIN" then
        HealCommLib.RegisterCallback(self, "HealComm_HealStarted", "HealComm_HealUpdated")
        HealCommLib.RegisterCallback(self, "HealComm_HealStopped")
        HealCommLib.RegisterCallback(self, "HealComm_HealDelayed", "HealComm_HealUpdated")
        HealCommLib.RegisterCallback(self, "HealComm_HealUpdated")
        HealCommLib.RegisterCallback(self, "HealComm_ModifierChanged")
        HealCommLib.RegisterCallback(self, "HealComm_GUIDDisappeared")
    end
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

function HealComm:Update(unit)
    -- local amount, targetGUID, num, frame, unitframe, healType
    -- if self.Settings.showHots then
	-- 	healType = HealCommLib.ALL_HEALS
	-- else
	-- 	healType = HealCommLib.CASTED_HEALS
    -- end
    -- local amount = (HealCommLib:GetHealAmount(DMW.Friends.Units[unit].GUID, healType, DMW.Time + self.Settings.timeframe) or 0) * (HealCommLib:GetHealModifier(targetGUID) or 1)
    -- DMW.Friends.Units[unit].GUID.PredictedHeal = amount
end

function HealComm:Update(unit)
    -- if not self.PartyGUIDs.Init then
    --     for i = 1, 5 do
    --         for k, Friend in pairs(DMW.Friends.Units) do
    --             if Friend.Pointer == ObjectPointer("party"..i) then
    --                 self.PartyGUIDs["party"..i] = Friend
    --             end
    --         end
    --     end
    --     self.PartyGUIDs.Init = true
    -- end
    -- -- self.PartyGUIDs[partyi].PredictedHeal = 0
    -- self.PartyGUIDs[partyi].Health = UnitHealth(partyi)
    if UnitExists(unit) then
        for k, Friend in pairs(DMW.Friends.Units) do
            if Friend.GUID == ObjectGUID(unit) and (Friend.PredTime and DMW.Time > Friend.PredTime) then
                Friend.PredictedHeal = nil
                Friend.Health = UnitHealth(unit)
                break
            end
        end
    end
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
        if amount > 0 then
            for k,v in pairs(DMW.Friends.Units) do
                if v.GUID == targetGUID then
                    v.PredictedHeal = amount
                    v.PredTime = DMW.Time + self.Settings.timeframe
                    v.Health = v.Health + v.PredictedHeal
                end
            end
        end
    end
end


