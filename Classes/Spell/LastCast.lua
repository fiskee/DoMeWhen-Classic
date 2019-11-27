local DMW = DMW
local WaitForSuccess = 0
local lastCastFrame = CreateFrame("Frame")
local Spell = DMW.Classes.Spell

function Spell:LastCast(Index)
    Index = Index or 1
    if DMW.Player.LastCast and DMW.Player.LastCast[Index] then
        return DMW.Player.LastCast[Index].SpellName == self.SpellName
    end
    return false
end

function Spell:TimeSinceLastCast()
    if self.LastCastTime > 0 then
        return DMW.Time - self.LastCastTime
    end
    return 999
end

local function AddSpell(SpellID)
    if not DMW.Player.LastCast then
        DMW.Player.LastCast = {}
    end
    local SpellName = GetSpellInfo(SpellID)
    for k, v in pairs(DMW.Player.Spells) do
        if v.SpellName == SpellName then
            local Temp = {}
            Temp.SpellName = v.SpellName
            Temp.CastTime = DMW.Time
            tinsert(DMW.Player.LastCast, 1, Temp)
            if #DMW.Player.LastCast == 10 then
                DMW.Player.LastCast[10] = nil
            end
            return true
        end
    end
    return false
end

local function EventTracker(self, event, ...)
    local SourceUnit = select(1, ...)
    local SpellID = select(3, ...)
    if SourceUnit == "player" and GetObjectWithGUID and DMW.Player.Spells then
        if event == "UNIT_SPELLCAST_START" then
            if AddSpell(SpellID) then
                WaitForSuccess = SpellID
            end
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            local SpellName = GetSpellInfo(SpellID)
            if WaitForSuccess == SpellID then
                DMW.Player.LastCast[1].SuccessTime = DMW.Time
                WaitForSuccess = 0
            else
                if AddSpell(SpellID) then
                    DMW.Player.LastCast[1].SuccessTime = DMW.Time
                end     
            end
            for k, v in pairs(DMW.Player.Spells) do
                if v.SpellName == SpellName then
                    v.LastCastTime = DMW.Time
                end
            end
        elseif event == "UNIT_SPELLCAST_STOP" then
            if WaitForSuccess == SpellID then
                tremove(DMW.Player.LastCast,1)
                WaitForSuccess = 0
            end
        end
    end
end

lastCastFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
lastCastFrame:SetScript("OnEvent", EventTracker)